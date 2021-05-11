module en_out(clk,rst,scl_i_data_en,scl_cfg_mode,scl_cfg_rsz,scl_o_data_en,en_ff0,en_ff1,en_ff2,en_ff3);
input clk,rst;
input scl_i_data_en,scl_cfg_mode,scl_cfg_rsz;
output scl_o_data_en;
reg scl_o_data_en;
reg [1:0]q;
output en_ff0,en_ff1,en_ff2,en_ff3; 
reg en_ff0,en_ff1,en_ff2,en_ff3,en_ff4,en_ff5;

always @(posedge clk or negedge rst) 
begin
    if(!rst) 
	begin
        en_ff0 <= 0;
        en_ff1 <= 0;
        en_ff2 <= 0;
        en_ff3 <= 0;
        en_ff4 <= 0;
        en_ff5 <= 0;
    end
    else 
	begin
        en_ff0  <= scl_i_data_en;
        en_ff1  <= en_ff0;
        en_ff2  <= en_ff1;
        en_ff3  <= en_ff2;
        en_ff4  <= en_ff3;
        en_ff5  <= en_ff4;
    end
end

always @(posedge clk or negedge rst) 
begin
    if(!rst) 
	begin
        q <= 2'b0;
    end
    else if(en_ff5==1) 
	begin
        q <= q+2'b1;
    end
    else 
	begin
        q <= 0;
    end
end

always @(posedge clk or negedge rst) 
begin
    if(!rst) 
	begin
        scl_o_data_en <= 0;
    end
    else if(scl_cfg_mode==0) 
	begin
        scl_o_data_en <= en_ff5; 
    end
    else if(scl_cfg_rsz==0 && (q==0 || q==2)) 
	begin
        scl_o_data_en <= en_ff5; 
    end
    else if(scl_cfg_rsz==1 && q==0) 
	begin
        scl_o_data_en <= en_ff5; 
    end
    else begin
        scl_o_data_en <= 0;
    end
end
endmodule
