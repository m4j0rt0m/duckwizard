/*
 * Module:      Matrix index example
 * Description: Brief example in how to index a value inside a 2D matrix
 * Author:      Abraham J. Ruiz R.
 * URL:         www.github.com/m4j0rt0m/matrix-idx-example
 */


`default_nettype none

module matrix (/*AUTOARG*/
   // Outputs
   x_idx_o, y_idx_o, matrix_value_o, valid_o,
   // Inputs
   clk_i, arstn_i, x_idx_i, y_idx_i
   );

  /* includes */
  `include "matrix.vh"

  /* local parameters */
  localparam MAX_VALUE = `MAX_VALUE;
  localparam NUM_X     = `NUM_X;
  localparam NUM_Y     = `NUM_Y;
  localparam NUM_WIDTH = $clog2(MAX_VALUE+1);
  localparam X_IDX     = $clog2(NUM_X);
  localparam Y_IDX     = $clog2(NUM_Y);

  /* ctrl flow */
  input   wire                  clk_i;
  input   wire                  arstn_i;

  /* indexes */
  input   wire  [X_IDX-1:0]     x_idx_i;
  input   wire  [Y_IDX-1:0]     y_idx_i;
  output  wire  [X_IDX-1:0]     x_idx_o;
  output  wire  [Y_IDX-1:0]     y_idx_o;

  /* output value */
  output  wire  [NUM_WIDTH-1:0] matrix_value_o;
  output  wire                  valid_o;

  /* genvars and integers */
  genvar I, J;

  /* regs and wires */
  wire  [(NUM_WIDTH*NUM_X)-1:0] matrix_block [NUM_Y-1:0];
  reg   [NUM_WIDTH-1:0]         matrix_value;
  reg   [X_IDX-1:0]             x_idx_int;
  reg   [Y_IDX-1:0]             y_idx_int;
  reg                           valid_int;

  /* assign matrix values */
  generate
    for(I = 0; I < NUM_Y; I = I + 1) begin: matrix_gen_y
      for(J = 0; J < NUM_X; J = J + 1) begin: matrix_gen_x
        assign matrix_block[I][(J*NUM_WIDTH)+:NUM_WIDTH] = (I*NUM_X)+J+1;
      end
    end
  endgenerate

  /* matrix value access */
  always @ (posedge clk_i, negedge arstn_i) begin
    if(~arstn_i) begin
      matrix_value <= {NUM_WIDTH{1'b0}};
      x_idx_int    <= {X_IDX{1'b0}};
      y_idx_int    <= {Y_IDX{1'b0}};
      valid_int    <= 1'b0;
    end
    else begin
      matrix_value <= matrix_block[y_idx_i][(x_idx_i*NUM_WIDTH)+:NUM_WIDTH];
      x_idx_int    <= x_idx_i;
      y_idx_int    <= y_idx_i;
      valid_int    <= 1'b1;
    end
  end

  /* output assignment */
  assign matrix_value_o = matrix_value;
  assign x_idx_o        = x_idx_int;
  assign y_idx_o        = y_idx_int;
  assign valid_o        = valid_int;

endmodule

`default_nettype wire
