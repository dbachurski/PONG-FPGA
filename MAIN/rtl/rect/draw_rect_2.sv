//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module draw_rect_2 (
    input  logic clk,
    input  logic rst,
    input  logic [10:0] ball_y_pos,
    input  logic mode_2,
    input  logic mode_3,
    input  logic [7:0] pos,
    output logic [10:0] y_position,
    vga_if.in vga,
    vga_if.out vga_out
);

 logic [11:0] rgb_nxt;
 logic [10:0] y_position_nxt;
 logic [26:0] divider, divider_nxt;
 
 import vga_pkg::*;


//local parameters
//********************************************************************//
   localparam HEIGHT = 100;
   localparam WIDTH = 15;
   localparam COLOR_WHITE = 12'hf_f_f; 
   localparam X_POSITION = HOR_PIXELS - 30;

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
        divider <= '0;
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
        divider <= divider_nxt;
      end 
    end


  //combinational 
  //********************************************************************//
  always_comb begin : rect_comb_blk
    if (vga_out.hcount <= X_POSITION && vga_out.hcount >=(X_POSITION - WIDTH ) && vga_out.vcount >= y_position  && vga_out.vcount <= (y_position + HEIGHT )) 
      rgb_nxt = COLOR_WHITE;
    else 
      rgb_nxt = vga.rgb;

    if(mode_2 == 1) begin

      if(divider >= 550000)
        divider_nxt = 0;
      else 
        if((ball_y_pos > y_position - 400) || (ball_y_pos < y_position + 400))
          divider_nxt = divider + 3;
        else
          divider_nxt = divider + 2;

      if(divider == 0) begin
          if((ball_y_pos > y_position + HEIGHT - 40) && (y_position + HEIGHT <= VER_PIXELS))
            y_position_nxt = y_position + 1;
          else if ((ball_y_pos < y_position + 40) && (y_position > 0) )
            y_position_nxt = y_position - 1;
          else 
            y_position_nxt = y_position;
      end else begin
          y_position_nxt = y_position;
      end

    end else begin

      divider_nxt = divider;

        if(mode_3 == 0) begin

          if (pos == 8'b00000001 && (y_position > 0) ) begin
            y_position_nxt = y_position - 5;
          end
          else if (pos == 8'b10000000  && (y_position + HEIGHT <= VER_PIXELS )) begin
            y_position_nxt = y_position + 5;
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

  end
        
 
//********************************************************************//
endmodule