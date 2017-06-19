//Confidential and proprietary information of Baidu, Inc
//////////////////////////////////////////////////////
//
//
//    Version:1.0
//    FileName: round_robin_4
//    Data last Modified:
//    Data Created:June. 3rd, 2017
//
//
//
//    Device:xcku115-flvf1924-2-e
//    Purpose: roung robin selection for 4 req source
//
//    Reference:
//    Revision History:
//    Rev 1.0 - First created, ruanyuan,
//    email: ruanyuan@baidu.com
//////////////////////////////////////////////////////
`timescale 1ns / 1ps
module round_robin_4(
   input        clk,
   input        rst,
   input  [3:0] req,
   output [1:0] sel
);
   reg [1:0] sel_r;
   assign sel = sel_r;

   always @ (posedge clk) begin
      if (rst) begin
         sel_r <= 'd0;
      end
      else if (sel_r == 2'd0) begin
         case (req)
            4'b0000: sel_r <= 2'd0;
            4'b0001: sel_r <= 2'd0;
            4'b0010: sel_r <= 2'd1;
            4'b0011: sel_r <= 2'd1;
            4'b0100: sel_r <= 2'd2;
            4'b0101: sel_r <= 2'd2;
            4'b0110: sel_r <= 2'd1;
            4'b0111: sel_r <= 2'd1;
            4'b1000: sel_r <= 2'd3;
            4'b1001: sel_r <= 2'd3;
            4'b1010: sel_r <= 2'd1;
            4'b1011: sel_r <= 2'd1;
            4'b1100: sel_r <= 2'd2;
            4'b1101: sel_r <= 2'd2;
            4'b1110: sel_r <= 2'd1;
            4'b1111: sel_r <= 2'd1;
         endcase
      end
      else if (sel_r == 2'd1) begin
         case (req)
            4'b0000: sel_r <= 2'd1;
            4'b0001: sel_r <= 2'd0;
            4'b0010: sel_r <= 2'd1;
            4'b0011: sel_r <= 2'd0;
            4'b0100: sel_r <= 2'd2;
            4'b0101: sel_r <= 2'd2;
            4'b0110: sel_r <= 2'd2;
            4'b0111: sel_r <= 2'd2;
            4'b1000: sel_r <= 2'd3;
            4'b1001: sel_r <= 2'd3;
            4'b1010: sel_r <= 2'd3;
            4'b1011: sel_r <= 2'd3;
            4'b1100: sel_r <= 2'd2;
            4'b1101: sel_r <= 2'd2;
            4'b1110: sel_r <= 2'd2;
            4'b1111: sel_r <= 2'd2;
         endcase
      end
      else if (sel_r == 2'd2) begin
         case (req)
            4'b0000: sel_r <= 2'd2;
            4'b0001: sel_r <= 2'd0;
            4'b0010: sel_r <= 2'd1;
            4'b0011: sel_r <= 2'd0;
            4'b0100: sel_r <= 2'd2;
            4'b0101: sel_r <= 2'd0;
            4'b0110: sel_r <= 2'd1;
            4'b0111: sel_r <= 2'd0;
            4'b1000: sel_r <= 2'd3;
            4'b1001: sel_r <= 2'd3;
            4'b1010: sel_r <= 2'd3;
            4'b1011: sel_r <= 2'd3;
            4'b1100: sel_r <= 2'd3;
            4'b1101: sel_r <= 2'd3;
            4'b1110: sel_r <= 2'd3;
            4'b1111: sel_r <= 2'd3;
         endcase
      end
      else if (sel_r == 2'd3) begin
         case (req)
            4'b0000: sel_r <= 2'd3;
            4'b0001: sel_r <= 2'd0;
            4'b0010: sel_r <= 2'd1;
            4'b0011: sel_r <= 2'd0;
            4'b0100: sel_r <= 2'd2;
            4'b0101: sel_r <= 2'd0;
            4'b0110: sel_r <= 2'd1;
            4'b0111: sel_r <= 2'd0;
            4'b1000: sel_r <= 2'd3;
            4'b1001: sel_r <= 2'd0;
            4'b1010: sel_r <= 2'd1;
            4'b1011: sel_r <= 2'd0;
            4'b1100: sel_r <= 2'd2;
            4'b1101: sel_r <= 2'd0;
            4'b1110: sel_r <= 2'd1;
            4'b1111: sel_r <= 2'd0;
         endcase
      end
   end

endmodule
