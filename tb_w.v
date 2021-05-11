module tb;
  
reg rst_n_scl;
reg clk_scl;
reg scl_i_vsync;
reg scl_i_hsync;
reg scl_i_data_en;

reg [7:0] scl_i_data_r;
reg [7:0] scl_i_data_g;
reg [7:0] scl_i_data_b;

reg scl_cfg_mode;
reg scl_cfg_rsz;
reg [1:0] scl_cfg_flt;

wire scl_o_vsync;
wire scl_o_hsync;
wire scl_o_data_en;
wire [7:0] scl_o_data_r;
wire [7:0] scl_o_data_g;
wire [7:0] scl_o_data_b;


parameter h = 1280;
parameter v = 1024;
parameter size = h*v*3+54;
parameter en_0 = 100;

reg[7:0] image_in [0:size-1];
reg[7:0] image_exp[0:size-1];
reg[7:0] image_out[0:size-1];

integer fp_r;
integer fp_p;
integer fp_w;

integer memory;

integer en_0_q;
integer q_i;
integer q_o;

reg[31:0] HEIGHT;
reg[31:0] WIDTH_IN;
reg[31:0] WIDTH_OUT;

top u3(
    .rst_n_scl(rst_n_scl),
    .clk_scl(clk_scl),
    .scl_i_vsync(scl_i_vsync),
    .scl_i_hsync(scl_i_hsync),
    .scl_i_data_en(scl_i_data_en),
    .scl_i_data_r(scl_i_data_r),
    .scl_i_data_g(scl_i_data_g),
    .scl_i_data_b(scl_i_data_b),
    .scl_cfg_mode(scl_cfg_mode),
    .scl_cfg_rsz(scl_cfg_rsz),
    .scl_cfg_flt(scl_cfg_flt),
    .scl_o_vsync(scl_o_vsync),
    .scl_o_hsync(scl_o_hsync),
    .scl_o_data_en(scl_o_data_en),
    .scl_o_data_r(scl_o_data_r),
    .scl_o_data_g(scl_o_data_g),
    .scl_o_data_b(scl_o_data_b)
);

initial begin

    rst_n_scl = 0;
    clk_scl = 0;
    scl_i_vsync = 1;
    scl_i_hsync = 1;
    scl_i_data_en = 0;

    scl_cfg_mode = 0;
    scl_cfg_rsz  = 0;
    scl_cfg_flt  = 3;
  

    #10  rst_n_scl = 1;

    fp_r=$fopen("input.bmp","rb");
    memory=$fread(image_in,fp_r);

    fp_p=$fopen("exp.bmp","rb");
    memory=$fread(image_exp,fp_p);

    HEIGHT[7 :0 ]=image_in[22];
    HEIGHT[15:8 ]=image_in[23];
    HEIGHT[23:16]=image_in[24];
    HEIGHT[31:24]=image_in[25];

    WIDTH_IN[7 :0 ]=image_in[18];
    WIDTH_IN[15:8 ]=image_in[19];
    WIDTH_IN[23:16]=image_in[20];
    WIDTH_IN[31:24]=image_in[21];

    #500 q_i=0;
    while (q_i<WIDTH_IN*HEIGHT*3) 
	begin
        @(posedge clk_scl); 
        if(q_i%(3*WIDTH_IN)==0 && en_0_q <= en_0) 
		begin
            en_0_q = en_0_q+1;
            scl_i_data_en = 0;
        end
        else 
		begin
            en_0_q = 0;
            scl_i_data_en = 1;
            scl_i_data_r  = image_in[54+q_i+0];
            scl_i_data_g  = image_in[54+q_i+1];
            scl_i_data_b  = image_in[54+q_i+2];
            q_i=q_i+3;
        end
    end

    #200 scl_i_data_en = 0;
end


initial begin
    #200 q_o=0;

    //  head
    for(q_o=0;q_o<54; q_o=q_o+1) 
	begin
        image_out[q_o]=image_in[q_o];
    end

    WIDTH_OUT[7 :0 ]=image_out[18];
    WIDTH_OUT[15:8 ]=image_out[19];
    WIDTH_OUT[23:16]=image_out[20];
    WIDTH_OUT[31:24]=image_out[21];

    if(scl_cfg_mode == 0) 
	begin
        WIDTH_OUT = WIDTH_OUT;
    end
    else if(scl_cfg_rsz == 0) 
	begin
        WIDTH_OUT = WIDTH_OUT/2;
    end
    else begin
        WIDTH_OUT = WIDTH_OUT/4;
    end

    image_out[18]=WIDTH_OUT[7 :0 ];
    image_out[19]=WIDTH_OUT[15:8 ];
    image_out[20]=WIDTH_OUT[23:16];
    image_out[21]=WIDTH_OUT[31:24];

    // image 
    q_o=0;
    while (q_o<WIDTH_OUT*HEIGHT*3) begin
        @(posedge clk_scl); 
        if(scl_o_data_en) begin
            image_out[54+q_o+0]=scl_o_data_r;
            image_out[54+q_o+1]=scl_o_data_g;
            image_out[54+q_o+2]=scl_o_data_b;
            if(image_out[54+q_o+0] != image_exp[54+q_o+0] ) begin
                $display("ERROR" );
            end
            if(image_out[54+q_o+1] != image_exp[54+q_o+1] ) begin
               $display("ERROR" );
            end
            if(image_out[54+q_o+2] != image_exp[54+q_o+2] ) begin
              $display("ERROR" );
            end
            q_o=q_o+3;
        end
    end

    //  output
    fp_w=$fopen("out.bmp","wb");
    for(q_o=0;q_o<WIDTH_OUT*HEIGHT*3+54; q_o=q_o+1) begin
        if(q_o<54) begin
            $fwrite(fp_w, "%c", image_exp[q_o]); 
        end
        else begin
            $fwrite(fp_w, "%c", image_out[q_o]);
        end
    end

    $fclose(fp_r);
    $fclose(fp_p);
    $fclose(fp_w);

    $finish;
end

always #5 clk_scl = !clk_scl;


   
endmodule 

