module top (rst_n_scl,clk_scl,scl_i_vsync,scl_i_hsync,scl_i_data_en,scl_i_data_r,
    scl_i_data_g,scl_i_data_b,scl_cfg_mode,scl_cfg_rsz,scl_cfg_flt,scl_o_vsync,scl_o_hsync,
    scl_o_data_en,scl_o_data_r,scl_o_data_g,scl_o_data_b);

input rst_n_scl,clk_scl;
input scl_i_data_en,scl_cfg_mode,scl_cfg_rsz;
input [1:0] scl_cfg_flt;
input scl_i_vsync;
input scl_i_hsync;
input[7:0]scl_i_data_r;
input[7:0]scl_i_data_g;
input[7:0]scl_i_data_b;
output[7:0]scl_o_data_r;
output[7:0]scl_o_data_g;
output[7:0]scl_o_data_b;
output scl_o_data_en;
output scl_o_vsync,scl_o_hsync;




hscalre hscaler(
    .rst_n_scl(rst_n_scl),
    .clk_scl(clk_scl),
    .en_ff0(en_ff0),
    .en_ff1(en_ff1),
    .en_ff2(en_ff2),
    .en_ff3(en_ff3),
    .scl_i_data_r(scl_i_data_r),
    .scl_i_data_g(scl_i_data_g),
    .scl_i_data_b(scl_i_data_b),
    .scl_cfg_mode(scl_cfg_mode),
    .scl_cfg_flt(scl_cfg_flt),
    .scl_o_data_r(scl_o_data_r),
    .scl_o_data_g(scl_o_data_g),
    .scl_o_data_b(scl_o_data_b)
);

en_out en(
    .rst(rst_n_scl),
    .clk(clk_scl),
    .en_ff0(en_ff0),
    .en_ff1(en_ff1),
    .en_ff2(en_ff2),
    .en_ff3(en_ff3),
    .scl_i_data_en(scl_i_data_en),
    .scl_cfg_mode(scl_cfg_mode),
    .scl_cfg_rsz(scl_cfg_rsz),
    .scl_o_data_en(scl_o_data_en)
);
endmodule