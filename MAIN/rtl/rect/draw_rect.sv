//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module draw_rect (
    input  logic clk,
    input  logic rst,
    input  logic btn_up,
    input  logic btn_down,
    input  logic [7:0] pos,
    input  logic mode,
    output logic [10:0] y_position,
    vga_if.in vga,
    vga_if.out vga_out
);

 logic [11:0] rgb_nxt;
 logic [10:0] y_position_nxt;

 import vga_pkg::*;


//local parameters
//********************************************************************//
   localparam HEIGHT = 100;
   localparam WIDTH = 15;
   localparam COLOR_WHITE = 12'hf_f_f;
   localparam X_POSITION = 30;

//procedural
//********************************************************************//
    always_ff @(posedge clk) begin
      if (rst) begin
        vga_out.hcount <= '0;
        vga_out.vcount <= '0;
        vga_out.hsync <= '0;
        vga_out.vsync <= '0;
        vga_out.hblnk <= '0;
        vga_out.vblnk <= '0;
        vga_out.rgb <= '0;
        y_position <= '0;
      end
      else begin
        vga_out.hcount <= vga.hcount;
        vga_out.vcount <= vga.vcount;
        vga_out.hsync <= vga.hsync;
        vga_out.vsync <= vga.vsync;
        vga_out.hblnk <= vga.hblnk;
        vga_out.vblnk <= vga.vblnk;
        vga_out.rgb <= rgb_nxt;
        y_position <= y_position_nxt;
      end
    end


  //combinational
  //********************************************************************//
  always_comb begin : rect_comb_blk
    if (vga_out.hcount >= X_POSITION && vga_out.hcount <= (X_POSITION + WIDTH ) && vga_out.vcount >= y_position  && vga_out.vcount <= (y_position+HEIGHT )) rgb_nxt = COLOR_WHITE;

    else
      rgb_nxt = vga.rgb;

    if (mode == 0) begin
      if (btn_up == 1  && (y_position > 0)) begin
        y_position_nxt = y_position - 10;
      end
      else if (btn_down == 1 && (y_position + HEIGHT <= VER_PIXELS )) begin
        y_position_nxt = y_position + 10;
      end
      else begin
         y_position_nxt = y_position;
      end

    end else begin
      if( pos <= 30) begin
        y_position_nxt = 0;
      end
      else if ( pos > 30 && pos < 235) begin 
        y_position_nxt = pos * 3 - 90;
      end 
      else begin
        y_position_nxt = 668;
      end
    end
   




  end

//********************************************************************//
endmodule