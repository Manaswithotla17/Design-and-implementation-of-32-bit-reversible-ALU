`timescale 1ns/1ps
module feynman_gate(input A, B, output P, Q);
  assign P = A;
  assign Q = A ^ B;
endmodule


module peres_gate(input A, B, C, output P, Q, R);
  assign P = A;
  assign Q = A ^ B;
  assign R = (A & B) ^ C;
endmodule


module fredkin_gate(input A, B, C, output P, Q, R);
  assign P = A;
  assign Q = (A) ? C : B;
  assign R = (A) ? B : C;
endmodule

`timescale 1ns/1ps

module peres_full_adder(
  input  A,
  input  B,
  input  Cin,
  output Sum,
  output Cout
);
  wire p1, q1, r1;
  wire p2, q2, r2;

  // First Peres: P1 = A, Q1 = A^B, R1 = (A&B)^0 = A&B
  peres_gate PG1 (.A(A), .B(B), .C(1'b0), .P(p1), .Q(q1), .R(r1));

  // Second Peres: inputs Q1 and Cin with R1 as third input
  // Outputs: P2 = Q1, Q2 = Q1 ^ Cin = A ^ B ^ Cin (SUM), R2 = (Q1 & Cin) ^ R1 => carry
  peres_gate PG2 (.A(q1), .B(Cin), .C(r1), .P(p2), .Q(q2), .R(r2));

  assign Sum  = q2;
  assign Cout = r2;

endmodule


module reversible_ripple_adder #(parameter WIDTH = 32)(
  input  [WIDTH-1:0] A,
  input  [WIDTH-1:0] B,
  input              Cin,
  output [WIDTH-1:0] Sum,
  output             Cout
);
  wire [WIDTH:0] carry;
  assign carry[0] = Cin;

  genvar i;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin : gen_adder_bits
      // peres_full_adder produces Sum[i] and carry[i+1]
      peres_full_adder pfa (
        .A(A[i]),
        .B(B[i]),
        .Cin(carry[i]),
        .Sum(Sum[i]),
        .Cout(carry[i+1])
      );
    end
  endgenerate
