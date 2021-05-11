module pixel_process (
  //input
    rst_n_scl,clk_scl,
    scl_cfg_flt,scl_cfg_mode,
    scl_i_data_r,scl_i_data_en,
   //output  
    o_dff5,scl_o_data_r);
  //input
input rst_n_scl,clk_scl;
input [7:0] scl_i_data_r;
input scl_cfg_mode;
input [1:0] scl_cfg_flt;
input scl_i_data_en;
   //output
output [7:0] scl_o_data_r;
output o_dff5;
reg [7:0] scl_o_data_r;

reg o_dff0,o_dff1,o_dff2,o_dff3,o_dff4,o_dff5;//output_en DFF
reg signed [10:0] coef_0,coef_1,coef_2,coef_3;//filter
reg [7:0] in_data_r0,in_data_r1,in_data_r2,in_data_r3,in_data_r4,in_data_r5;//data_in DFF
wire signed [8:0] re_r0,re_r1,re_r2,re_r3;//data_in symbol
reg signed [20:0] dff_r0,dff_r1,dff_r2,dff_r3;//add and mul
reg signed [21:0] dff1_r0,dff1_r1;
reg signed [22:0] dff2_r;
//filter
always @(posedge clk_scl or negedge rst_n_scl) begin
    if(!rst_n_scl) begin
        coef_0 <= 0;
        coef_1 <= 0;
        coef_2 <= 0;
        coef_3 <= 0;
    end
    else begin
        case(scl_cfg_flt)
            2'd0: begin
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
            default: begin
                coef_0 <= 0;
                coef_1 <= 512;
                coef_2 <= 0;
                coef_3 <= 0;
            end
        endcase
    end
end
////data_in symbol
assign re_r0 = {1'b0,in_data_r0};
assign re_r1 = {1'b0,in_data_r1};
assign re_r2 = {1'b0,in_data_r2};
assign re_r3 = {1'b0,in_data_r3};
//data_in DFF
always @(posedge clk_scl or negedge rst_n_scl) begin
    if(!rst_n_scl) begin
        in_data_r0  <= 8'b0;
        in_data_r1  <= 8'b0;
        in_data_r2  <= 8'b0;
        in_data_r3  <= 8'b0;
        in_data_r4  <= 8'b0;
        in_data_r5  <= 8'b0;
    end
    else begin
        in_data_r0  <= scl_i_data_r;
        in_data_r1  <= in_data_r0;
        in_data_r2  <= in_data_r1;
        in_data_r3  <= in_data_r2;
        in_data_r4  <= in_data_r3;
        in_data_r5  <= in_data_r4;
    end
end
//port processing
always @(posedge clk_scl or negedge rst_n_scl) begin
    if(!rst_n_scl) begin
        dff_r0  <= 0;
        dff_r1  <= 0;
        dff_r2  <= 0;
        dff_r3  <= 0;   
    end
    else if(o_dff2==1 && o_dff3==0) begin//first
        dff_r0  <= re_r0*coef_3;
        dff_r1  <= re_r1*coef_2;
        dff_r2  <= re_r2*coef_1;
        dff_r3  <= re_r2*coef_0;    
    end
    else if(o_dff0==0 && o_dff1==1) begin//dao shu 2
        dff_r0  <= re_r1*coef_3;
        dff_r1  <= re_r1*coef_2;
        dff_r2  <= re_r2*coef_1;
        dff_r3  <= re_r3*coef_0;  
    end
    else if(o_dff1==0 && o_dff2==1) begin//last
        dff_r0  <= re_r2*coef_3;
        dff_r1  <= re_r2*coef_2;
        dff_r2  <= re_r2*coef_1;
        dff_r3  <= re_r3*coef_0;  
    end
    else begin
        dff_r0  <= re_r0*coef_3;
        dff_r1  <= re_r1*coef_2;
        dff_r2  <= re_r2*coef_1;
        dff_r3  <= re_r3*coef_0;                
    end
end


always @(posedge clk_scl or negedge rst_n_scl) begin
    if(!rst_n_scl) begin
        dff1_r0  <= 0;
        dff1_r1  <= 0;   
    end
    else begin
        dff1_r0  <= dff_r0+dff_r1;
        dff1_r1  <= dff_r2+dff_r3;        
    end
end

always @(posedge clk_scl or negedge rst_n_scl) begin
    if(!rst_n_scl) begin
        dff2_r <= 0;    
    end
    else begin
        dff2_r <= dff1_r0+dff1_r1;        
    end
end

//平均
always @(posedge clk_scl or negedge rst_n_scl) begin
    if(!rst_n_scl) begin
        scl_o_data_r  <= 8'b0;        
    end
    else if(!scl_cfg_mode) begin
        scl_o_data_r <= in_data_r5;        
    end
    else begin   
        if(dff2_r<0) begin
            scl_o_data_r <= 8'b0;
        end
        else if(dff2_r>130560) begin
            scl_o_data_r <= 255;
        end
        else begin
            scl_o_data_r <= dff2_r >> 9;
        end
 end
 end
 //data_out_DFF
always @(posedge clk_scl or negedge rst_n_scl) begin
    if(!rst_n_scl) begin
        o_dff0 <= 0;
        o_dff1 <= 0;
        o_dff2 <= 0;
        o_dff3 <= 0;
        o_dff4 <= 0;
        o_dff5 <= 0;
    end
    else begin
        o_dff0  <= scl_i_data_en;
        o_dff1  <= o_dff0;
        o_dff2  <= o_dff1;
        o_dff3  <= o_dff2;
        o_dff4  <= o_dff3;
        o_dff5  <= o_dff4;
    end
end
        
  
endmodule



