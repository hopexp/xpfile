module htop (
//input 
    rst_n_scl,clk_scl,
    scl_i_vsync,scl_i_hsync,
    scl_i_data_r,scl_i_data_g,scl_i_data_b,
    scl_cfg_mode,scl_cfg_rsz,scl_cfg_flt,scl_i_data_en,
 //output    
    scl_o_vsync,scl_o_hsync,
    scl_o_data_en,
    scl_o_data_r,scl_o_data_g,scl_o_data_b);
//input 
input rst_n_scl,clk_scl;
input scl_i_vsync,scl_i_hsync;
input [7:0] scl_i_data_r,scl_i_data_g,scl_i_data_b;
input scl_i_data_en,scl_cfg_mode,scl_cfg_rsz;
input [1:0] scl_cfg_flt;
//output 
output scl_o_vsync,scl_o_hsync;
output scl_o_data_en;
output [7:0] scl_o_data_r,scl_o_data_g,scl_o_data_b;

reg scl_o_vsync,scl_o_hsync;
reg scl_o_data_en;
wire [7:0] scl_o_data_r,scl_o_data_g,scl_o_data_b;
reg [1:0] counter;
//instance
pixel_process hscaler_r(
    .rst_n_scl(rst_n_scl),
    .clk_scl(clk_scl),
    .scl_i_data_r(scl_i_data_r),
    .scl_i_data_en(scl_i_data_en),
    .scl_cfg_mode(scl_cfg_mode),
    .scl_cfg_flt(scl_cfg_flt),
    .o_dff5(o_dff5),
    .scl_o_data_r(scl_o_data_r));

pixel_process hscaler_g(
    .rst_n_scl(rst_n_scl),
    .clk_scl(clk_scl),
    .scl_i_data_r(scl_i_data_g),
    .scl_i_data_en(scl_i_data_en),
    .scl_cfg_mode(scl_cfg_mode),
    .scl_cfg_flt(scl_cfg_flt),
    .o_dff5(o_dff5),
    .scl_o_data_r(scl_o_data_g));
	
pixel_process hscaler_b(
    .rst_n_scl(rst_n_scl),
    .clk_scl(clk_scl),
    .scl_i_data_en(scl_i_data_en),
    .scl_i_data_r(scl_i_data_b),
    .scl_cfg_mode(scl_cfg_mode),
    .scl_cfg_flt(scl_cfg_flt),
    .o_dff5(o_dff5),
    .scl_o_data_r(scl_o_data_b));
//counter 
always @(posedge clk_scl or negedge rst_n_scl) begin
    if(!rst_n_scl) begin
        counter <= 0;
    end
    else if(o_dff5) begin
        counter <= counter+1;
    end
    else begin
        counter <= 0;
    end
end
//suofang
always @(posedge clk_scl or negedge rst_n_scl) begin
    if(!rst_n_scl) begin
        scl_o_data_en <= 0;
    end
    else if(!scl_cfg_mode) begin
        scl_o_data_en <= o_dff5; 
    end
    else if(scl_cfg_rsz==0 && (counter==0 || counter==2)) begin
        scl_o_data_en <= o_dff5; 
    end
    else if(scl_cfg_rsz==1 && counter==0) begin
        scl_o_data_en <= o_dff5; 
    end
    else begin
        scl_o_data_en <= 0;
    end
end

endmodule





