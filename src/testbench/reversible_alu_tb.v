`timescale 1ns/1ps

module tb_reversible_32alu;

  reg  [3:0]  A_sw, B_sw;     
  reg  [3:0]  S_sw;          
  reg         MODE_sw;       

  wire [31:0] F;
  wire        carry_out, zero_flag, eq_flag;

  wire [31:0] A = {28'b0, A_sw};
  wire [31:0] B = {28'b0, B_sw};

  reversible_alu_32bit uut (
    .A(A),
    .B(B),
    .S(S_sw),
    .MODE(MODE_sw),
    .F(F),
    .carry_out(carry_out),
    .zero_flag(zero_flag),
    .eq_flag(eq_flag)
  );

  wire [3:0] F_led = F[3:0];

 
  initial begin

    $dumpfile("reversible_alu.vcd");
    $dumpvars(0, tb_reversible_32alu);

 
    A_sw = 4'b0000;
    B_sw = 4'b0000;
    S_sw = 4'b0000;
    MODE_sw = 1;
    #10;

   
    $display("Time | A | B | S | MODE | F | carry | zero | eq");
    $display("---------------------------------------------------");

   
    A_sw = 4'b0101; B_sw = 4'b0011; S_sw = 4'b0000; MODE_sw = 0; #10;
    $display("%4dns | %b | %b | %b | %b | %h | %b | %b | %b", 
             $time, A_sw, B_sw, S_sw, MODE_sw, F_led, carry_out, zero_flag, eq_flag);

   
    A_sw = 4'b0110; B_sw = 4'b0010; S_sw = 4'b0001; MODE_sw = 1; #10;
    $display("%4dns | %b | %b | %b | %b | %h | %b | %b | %b", 
             $time, A_sw, B_sw, S_sw, MODE_sw, F_led, carry_out, zero_flag, eq_flag);

   
    A_sw = 4'b1010; B_sw = 4'b1100; S_sw = 4'b0010; MODE_sw = 0; #10;
    $display("%4dns | %b | %b | %b | %b | %h | %b | %b | %b", 
             $time, A_sw, B_sw, S_sw, MODE_sw, F_led, carry_out, zero_flag, eq_flag);

   
    A_sw = 4'b1111; B_sw = 4'b0001; S_sw = 4'b0011; MODE_sw = 1; #10;
    $display("%4dns | %b | %b | %b | %b | %h | %b | %b | %b", 
             $time, A_sw, B_sw, S_sw, MODE_sw, F_led, carry_out, zero_flag, eq_flag);

    
    A_sw = 4'b0110; B_sw = 4'b1010; S_sw = 4'b0100; MODE_sw = 0; #10;
    $display("%4dns | %b | %b | %b | %b | %h | %b | %b | %b", 
             $time, A_sw, B_sw, S_sw, MODE_sw, F_led, carry_out, zero_flag, eq_flag);


    $stop;
  end

endmodule
