module tb;

reg rst_n_scl,clk_scl;
reg scl_i_vsync,scl_i_hsync;
reg scl_i_data_en;
reg [7:0] scl_i_data_r,scl_i_data_g,scl_i_data_b;
reg scl_cfg_mode,scl_cfg_rsz;
reg [1:0] scl_cfg_flt;

wire scl_o_vsync,scl_o_hsync;
wire scl_o_data_en;
wire [7:0] scl_o_data_r,scl_o_data_g,scl_o_data_b;

parameter image_width = 1280;
parameter image_high = 1024;
parameter max_size = image_width*image_high*3+54;
parameter en_e_time = 100;

reg[7:0] image_in [0:max_size-1];
reg[7:0] image_exp[0:max_size-1];
reg[7:0] image_out[0:max_size-1];

integer fp_r;
integer fp_p;
integer fp_w;

integer mem;

integer en_e_time_cnt;
integer cnt_i;
integer cnt_o;

reg[31:0] HEIGHT;
reg[31:0] WIDTH_IN;
reg[31:0] WIDTH_OUT;

htop u1(
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

initial
  begin

    scl_cfg_mode = 1;
    scl_cfg_rsz  = 0;
    scl_cfg_flt  = 0;

    rst_n_scl = 0;
    clk_scl = 0;
    scl_i_vsync = 1;
    scl_i_hsync = 1;
    scl_i_data_en = 0;



    #10  rst_n_scl = 1;

    fp_r=$fopen("input.bmp","rb");
    mem=$fread(image_in,fp_r);

    fp_p=$fopen("exp.bmp","rb");
    mem=$fread(image_exp,fp_p);


    {HEIGHT[31:24],HEIGHT[23:16],HEIGHT[15:8 ],HEIGHT[7 :0 ]}
    ={image_in[25],image_in[24],image_in[23],image_in[22]};

    {WIDTH_IN[31:24],WIDTH_IN[23:16],WIDTH_IN[15:8],WIDTH_IN[7:0]}
    ={image_in[21],image_in[20],image_in[19],image_in[18]};

    #500 ;

    cnt_i=0;
    while (cnt_i<WIDTH_IN*HEIGHT*3)
      begin
        @(posedge clk_scl);
        if(cnt_i%(3*WIDTH_IN)==0 && en_e_time_cnt <= en_e_time)
          begin
            en_e_time_cnt = en_e_time_cnt+1;
            scl_i_data_en = 0;
          end
        else
          begin
            en_e_time_cnt = 0;
            scl_i_data_en = 1;
            scl_i_data_r  = image_in[54+cnt_i+0];
            scl_i_data_g  = image_in[54+cnt_i+1];
            scl_i_data_b  = image_in[54+cnt_i+2];
            cnt_i=cnt_i+3;
          end
      end

   #200 scl_i_data_en = 0;
  end

initial
  begin
    #500 cnt_o=0;

  
    for(cnt_o=0;cnt_o<54; cnt_o=cnt_o+1)
      begin
        image_out[cnt_o]=image_in[cnt_o];
      end

    {WIDTH_OUT[31:24],WIDTH_OUT[23:16],WIDTH_OUT[15:8 ],WIDTH_OUT[7 :0 ]}
    ={image_out[21],image_out[20],image_out[19],image_out[18]};

    if(!scl_cfg_mode)
      begin
        WIDTH_OUT = WIDTH_OUT;
      end
    else if(!scl_cfg_rsz)
      begin
        WIDTH_OUT = WIDTH_OUT[31:1];
      end
    else
      begin
        WIDTH_OUT = WIDTH_OUT[31:2];
      end

    {image_out[21],image_out[20],image_out[19],image_out[18]}=
    {WIDTH_OUT[31:24],WIDTH_OUT[23:16],WIDTH_OUT[15:8 ],WIDTH_OUT[7 :0 ]};

  
    cnt_o=0;
    while (cnt_o<WIDTH_OUT*HEIGHT*3)
      begin
        @(posedge clk_scl);
        if(scl_o_data_en)
          begin
            image_out[54+cnt_o+0]=scl_o_data_r;
            image_out[54+cnt_o+1]=scl_o_data_g;
            image_out[54+cnt_o+2]=scl_o_data_b;
            if(image_out[54+cnt_o+0] != image_exp[54+cnt_o+0] )
              begin
           $display("DIFF R (%d,%d) sim %d, exp %d\n",(cnt_o/3+1)%WIDTH_OUT,(cnt_o/3+1)/WIDTH_OUT,image_out[54+cnt_o+0],image_exp[54+cnt_o+0] );
          
              end
            if(image_out[54+cnt_o+1] != image_exp[54+cnt_o+1] )
              begin
                $display("ERROR");

              end
            if(image_out[54+cnt_o+2] != image_exp[54+cnt_o+2] )
              begin
                $display("ERROR");
              end
            cnt_o=cnt_o+3;
          end
      end

 
    fp_w=$fopen("out.bmp","wb");
    for(cnt_o=0;cnt_o<WIDTH_OUT*HEIGHT*3+54; cnt_o=cnt_o+1)
      begin
        if(cnt_o<54)
          begin
            $fwrite(fp_w, "%c", image_exp[cnt_o]); 
          end
        else
          begin
            $fwrite(fp_w, "%c", image_out[cnt_o]);
          end
      end


    $finish;
  end

always #5 clk_scl = ~clk_scl;


endmodule





