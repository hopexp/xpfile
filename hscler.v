module hscaler (rst_n_scl,clk_scl,en_ff0,en_ff1,en_ff2,en_ff3,scl_i_data_r,scl_i_data_g,scl_i_data_b,scl_cfg_mode,
scl_cfg_flt,scl_o_data_r,scl_o_data_g,scl_o_data_b);

input en_ff0,en_ff1,en_ff2,en_ff3;
input rst_n_scl,clk_scl;
input scl_cfg_mode; 
input [1:0] scl_cfg_flt;

input[7:0]scl_i_data_r;
input[7:0]scl_i_data_g;
input[7:0]scl_i_data_b;
output[7:0]scl_o_data_r;
output[7:0]scl_o_data_g;
output[7:0]scl_o_data_b;



reg[7:0]scl_o_data_r;
reg[7:0]scl_o_data_g;
reg[7:0]scl_o_data_b;


//input r g b 
reg [7:0] data_in_r_0,data_in_r_1,data_in_r_2,data_in_r_3,data_in_r_4,data_in_r_5;
reg [7:0] data_in_g_0,data_in_g_1,data_in_g_2,data_in_g_3,data_in_g_4,data_in_g_5;
reg [7:0] data_in_b_0,data_in_b_1,data_in_b_2,data_in_b_3,data_in_b_4,data_in_b_5;

always @(posedge clk_scl or negedge rst_n_scl) 
begin
    if(!rst_n_scl) 
	begin
        data_in_r_0  <= 8'b0;
        data_in_r_1  <= 8'b0;
        data_in_r_2  <= 8'b0;
        data_in_r_3  <= 8'b0;
        data_in_r_4  <= 8'b0;
        data_in_r_5  <= 8'b0;
    end
    else 
	begin
        data_in_r_0  <= scl_i_data_r;
        data_in_r_1  <= data_in_r_0;
        data_in_r_2  <= data_in_r_1;
        data_in_r_3  <= data_in_r_2;
        data_in_r_4  <= data_in_r_3;
        data_in_r_5  <= data_in_r_4;
    end
end



always @(posedge clk_scl or negedge rst_n_scl) 
begin
    if(!rst_n_scl) 
	begin
        data_in_g_0  <= 8'b0;
        data_in_g_1  <= 8'b0;
        data_in_g_2  <= 8'b0;
        data_in_g_3  <= 8'b0;
        data_in_g_4  <= 8'b0;
        data_in_g_5  <= 8'b0;
    end
    else 
	begin
        data_in_g_0  <= scl_i_data_g;
        data_in_g_1  <= data_in_g_0;
        data_in_g_2  <= data_in_g_1;
        data_in_g_3  <= data_in_g_2;
        data_in_g_4  <= data_in_g_3;
        data_in_g_5  <= data_in_g_4;
    end
end



always @(posedge clk_scl or negedge rst_n_scl) 
begin
    if(!rst_n_scl) 
	begin
        data_in_b_0  <= 8'b0;
        data_in_b_1  <= 8'b0;
        data_in_b_2  <= 8'b0;
        data_in_b_3  <= 8'b0;
        data_in_b_4  <= 8'b0;
        data_in_b_5  <= 8'b0;
    end
    else 
	begin
        data_in_b_0  <= scl_i_data_b;
        data_in_b_1  <= data_in_b_0;
        data_in_b_2  <= data_in_b_1;
        data_in_b_3  <= data_in_b_2;
        data_in_b_4  <= data_in_b_3;
        data_in_b_5  <= data_in_b_4;
    end
end

//???????
reg signed [10:0] coef_0,coef_1,coef_2,coef_3;
 
always @(posedge clk_scl or negedge rst_n_scl) 
begin 
 if (!rst_n_scl)
   begin
      coef_0 <= 0;
			coef_1 <= 0;
			coef_2 <= 0;
			coef_3 <= 0;
		end
  else 
  begin
  case(scl_cfg_flt)
    2'd0:begin 
		  coef_0 <= -3;
			coef_1 <= 498;
			coef_2 <= 18;
			coef_3 <= -1;
			end 
			
	  2'd1: begin 
		  coef_0 <= -38;
			coef_1 <= 376;
			coef_2 <= 202;
			coef_3 <= -28;
			end 
			
	  2'd2: begin
		  coef_0 <= -28;
			coef_1 <= 202;
			coef_2 <= 376;
			coef_3 <= -38;
			end
			
	  2'd3: begin
		  coef_0 <= -1;
			coef_1 <= 18;
			coef_2 <= 498;
			coef_3 <= -3;
			end
			
	default:begin
	    coef_0 <= 0;
			coef_1 <= 512;
			coef_2 <= 0;
			coef_3 <= 0;
			end
   endcase
  end
end 
//???&???

wire signed [8:0] itmp_r_0,itmp_r_1,itmp_r_2,itmp_r_3;
wire signed [8:0] itmp_g_0,itmp_g_1,itmp_g_2,itmp_g_3;
wire signed [8:0] itmp_b_0,itmp_b_1,itmp_b_2,itmp_b_3;


reg signed [20:0] ff_r_0,ff_r_1,ff_r_2,ff_r_3;
reg signed [20:0] ff_g_0,ff_g_1,ff_g_2,ff_g_3;
reg signed [20:0] ff_b_0,ff_b_1,ff_b_2,ff_b_3;

assign itmp_r_0 = {1'b0,data_in_r_0};
assign itmp_r_1 = {1'b0,data_in_r_1};
assign itmp_r_2 = {1'b0,data_in_r_2};
assign itmp_r_3 = {1'b0,data_in_r_3};

assign itmp_g_0 = {1'b0,data_in_g_0};
assign itmp_g_1 = {1'b0,data_in_g_0};
assign itmp_g_2 = {1'b0,data_in_g_0};
assign itmp_g_3 = {1'b0,data_in_g_0};

assign itmp_b_0 = {1'b0,data_in_b_0};
assign itmp_b_1 = {1'b0,data_in_b_0};
assign itmp_b_2 = {1'b0,data_in_b_0};
assign itmp_b_3 = {1'b0,data_in_b_0};

always @(posedge clk_scl or negedge rst_n_scl) 
begin
    if(!rst_n_scl) 
	begin
        ff_r_0  <= 0;
        ff_r_1  <= 0;
        ff_r_2  <= 0;
        ff_r_3  <= 0;

        ff_g_0  <= 0;
        ff_g_1  <= 0;
        ff_g_2  <= 0;
        ff_g_3  <= 0;

        ff_b_0  <= 0;
        ff_b_1  <= 0;
        ff_b_2  <= 0;
        ff_b_3  <= 0;
    end
    else if(en_ff2==1 && en_ff3==0) //???????????
	    begin
        ff_r_0  <= itmp_r_0*coef_3;
        ff_r_1  <= itmp_r_1*coef_2;
        ff_r_2  <= itmp_r_2*coef_1;
        ff_r_3  <= itmp_r_2*coef_0;

        ff_g_0  <= itmp_g_0*coef_3;
        ff_g_1  <= itmp_g_1*coef_2;
        ff_g_2  <= itmp_g_2*coef_1;
        ff_g_3  <= itmp_g_2*coef_0;

        ff_b_0  <= itmp_b_0*coef_3;
        ff_b_1  <= itmp_b_1*coef_2;
        ff_b_2  <= itmp_b_2*coef_1;
        ff_b_3  <= itmp_b_2*coef_0;
    end
    else if(en_ff0==0 && en_ff1==1) //?????????????
	    begin
        ff_r_0  <= itmp_r_1*coef_3;
        ff_r_1  <= itmp_r_1*coef_2;
        ff_r_2  <= itmp_r_2*coef_1;
        ff_r_3  <= itmp_r_3*coef_0;

        ff_g_0  <= itmp_g_1*coef_3;
        ff_g_1  <= itmp_g_1*coef_2;
        ff_g_2  <= itmp_g_2*coef_1;
        ff_g_3  <= itmp_g_3*coef_0;

        ff_b_0  <= itmp_b_1*coef_3;
        ff_b_1  <= itmp_b_1*coef_2;
        ff_b_2  <= itmp_b_2*coef_1;
        ff_b_3  <= itmp_b_3*coef_0;
        end
    else if(en_ff1==0 && en_ff2==1) //?????????????
	    begin
        ff_r_0  <= itmp_r_2*coef_3;
        ff_r_1  <= itmp_r_2*coef_2;
        ff_r_2  <= itmp_r_2*coef_1;
        ff_r_3  <= itmp_r_3*coef_0;

        ff_g_0  <= itmp_g_2*coef_3;
        ff_g_1  <= itmp_g_2*coef_2;
        ff_g_2  <= itmp_g_2*coef_1;
        ff_g_3  <= itmp_g_3*coef_0;

        ff_b_0  <= itmp_b_2*coef_3;
        ff_b_1  <= itmp_b_2*coef_2;
        ff_b_2  <= itmp_b_2*coef_1;
        ff_b_3  <= itmp_b_3*coef_0;
       end
	    else
        begin
        ff_r_0  <= itmp_r_0*coef_3;
        ff_r_1  <= itmp_r_1*coef_2;
        ff_r_2  <= itmp_r_2*coef_1;
        ff_r_3  <= itmp_r_3*coef_0;
                                    
        ff_g_0  <= itmp_g_0*coef_3;
        ff_g_1  <= itmp_g_1*coef_2;
        ff_g_2  <= itmp_g_2*coef_1;
        ff_g_3  <= itmp_g_3*coef_0;
                                    
        ff_b_0  <= itmp_b_0*coef_3;
        ff_b_1  <= itmp_b_1*coef_2;
        ff_b_2  <= itmp_b_2*coef_1;
        ff_b_3  <= itmp_b_3*coef_0;
        end
end


//??????

reg signed [21:0] ff1_r_0,ff1_r_1;
reg signed [21:0] ff1_g_0,ff1_g_1;
reg signed [21:0] ff1_b_0,ff1_b_1;

always @(posedge clk_scl or negedge rst_n_scl) 
begin
    if(!rst_n_scl) 
	begin
        ff1_r_0  <= 0;
        ff1_r_1  <= 0;

        ff1_g_0  <= 0;
        ff1_g_1  <= 0;

        ff1_b_0  <= 0;
        ff1_b_1  <= 0;
    end
    else 
	begin
        ff1_r_0  <= ff_r_0+ff_r_1;
        ff1_r_1  <= ff_r_2+ff_r_3;

        ff1_g_0  <= ff_g_0+ff_g_1;
        ff1_g_1  <= ff_g_2+ff_g_3;

        ff1_b_0  <= ff_b_0+ff_b_1;
        ff1_b_1  <= ff_b_2+ff_b_3;
    end
end

//??????

reg signed [22:0] ff2_r;
reg signed [22:0] ff2_g;
reg signed [22:0] ff2_b;
always @(posedge clk_scl or negedge rst_n_scl) 
begin
    if(!rst_n_scl) 
	begin
        ff2_r <= 0;
        ff2_g <= 0;
        ff2_b <= 0;
    end
    else 
	begin
        ff2_r <= ff1_r_0+ff1_r_1;
        ff2_g <= ff1_g_0+ff1_g_1;
        ff2_b <= ff1_b_0+ff1_b_1;
    end
end

//output r g b 
always @(posedge clk_scl or negedge rst_n_scl) 
begin
    if(!rst_n_scl) 
	begin
        scl_o_data_r  <= 8'b0;
        scl_o_data_g  <= 8'b0;
        scl_o_data_b  <= 8'b0;
    end
    else if(scl_cfg_mode==0) 
	begin
        scl_o_data_r <= data_in_r_5;
        scl_o_data_g <= data_in_g_5;
        scl_o_data_b <= data_in_b_5;
    end
    else 
	begin
        
        if(ff2_r<0) 
		begin
            scl_o_data_r <= 0;
        end
        else if(ff2_r>130560) 
		begin
            scl_o_data_r <= 255;
        end
        else begin
            scl_o_data_r <= ff2_r[16:9];
        end

        
        if(ff2_g<0) begin
            scl_o_data_g <= 0;
        end
        else if(ff2_g>130560) 
		begin
            scl_o_data_g <= 255;
        end
        else begin
            scl_o_data_g <= ff2_g[16:9];
        end

        
        if(ff2_b<0) begin
            scl_o_data_b <= 0;
        end
        else if(ff2_b>130560) 
		begin
            scl_o_data_b <= 255;
        end
        else begin
            scl_o_data_b <= ff2_b[16:9];
        end
    end
end
endmodule




