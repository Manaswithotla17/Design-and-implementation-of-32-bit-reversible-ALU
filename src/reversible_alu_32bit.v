module reversible_alu_32bit(
  input  [31:0] A,
  input  [31:0] B,
  input  [3:0]  S,   
  input         MODE, 
  output [31:0] F,
  output        carry_out,
  output        zero_flag,
  output        eq_flag
);

  wire [31:0] sum, diff, and_out, or_out, xor_out,shl_out,shr_out;

 
  assign sum     = A + B;
  assign diff    = A - B;


  assign and_out = A & B;
  assign or_out  = A | B;
  assign xor_out = A ^ B;
  assign shl_out = A << 1; 
  assign shr_out = A >> 1;

  reg [31:0] temp_result;
  always @(*) begin
    case (S)
      4'b0000: temp_result = sum;      
      4'b0001: temp_result = diff;     
      4'b0010: temp_result = and_out;  
      4'b0011: temp_result = or_out;   
      4'b0100: temp_result = xor_out;
      4'b0101: temp_result = shl_out; 
      4'b0110: temp_result = shr_out;  
      default: temp_result = 32'b0;
    endcase
  end

  dual_mode_logic #(32) dml_inst (
    .static_in(temp_result),
    .dynamic_in(~temp_result), 
    .MODE(MODE),
    .DML_out(F)
  );
