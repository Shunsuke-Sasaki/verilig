module mul(A,B,O,ck,start,fin);
input [7:0] A, B;
input ck,start;
output [16:0] O;

reg [4:0] st;
reg [7:0] AIN, BIN;
reg [16:0] O;

always @(posedge ck) begin
    if (start) begin
        AIN <= A;
        BIN <= B;
        st <= 0;
    end 
    else begin
        case (st)
        0: begin
            O <= O + (AIN & 1 ? BIN : 0);
            AIN<=(AIN>>1);
            st <= 1;
            end
        1: begin
            O <= (O<<1) + (AIN & 1 ? BIN : 0);
            AIN<=(AIN>>1);
            st <= 2;
            end
        2: begin
            O <= (O<<1) + (AIN & 1 ? BIN : 0);
            AIN <= (AIN >>1);
            st <= 3;
            end
        3: begin
            O <= (O<<1) + (AIN & 1 ? BIN : 0);
            AIN <= (AIN >>1);
            st <= 4;
            end
        4: begin
            O <= (O<<1) + (AIN & 1 ? BIN : 0);
            AIN <= (AIN >>1);
            st <= 5;
            end
        5: begin
            O <= (O<<1) + (AIN & 1 ? BIN : 0);
            AIN <= (AIN >>1);
            st <= 6;
            end
        6: begin
            O <= (O<<1) + (AIN & 1 ? BIN : 0);
            AIN <= (AIN >>1);
            st<=7;
            end
        7: begin
            O <= (O<<1) + (AIN & 1 ? BIN : 0);
            st<=0;
            end
        default: begin
            st <= 0;
    endcase
  end
end
endmodule
