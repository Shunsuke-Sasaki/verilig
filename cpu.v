	
module CPU(clk,rst,IA,ID,DA,DD,RW);
input rst,clk;
input[15:0] ID;
output RW;
output [15:0] IA,DA;
inout [15:0] DD;

reg [1:0] stage;
reg FLAG;
reg RW_reg;
wire [7:0] IMM;
reg [15:0] INST;
wire [3:0] OPCODE, OPR1, OPR2, OPR3;
reg [15:0] PC, PCI, PCC;
reg [15:0] RF [0:15];
reg [15:0] FUA, FUB, FUC, LSUA,LSUB,LSUC;
wire [15:0] ABUS,BBUS,CBUS; 

assign IA = PC;
assign RW = RW_reg;
assign OPCODE = INST[15:12];
assign OPR1 = INST[11:8];
assign OPR2 = INST[7:4];
assign OPR3 = INST[3:0];
assign IMM = INST[7:0];
assign ABUS = (OPR2 == 0 ? 0:RF[OPR2]);
assign BBUS = (OPR3 == 0 ? 0:RF[OPR3]);
assign DD=(RW==0?LSUA:'b Z);
assign DA=LSUB;
assign CBUS=(OPCODE[3]==0?FUC:(OPCODE[3:1]=='b101 ? LSUC:(OPCODE=='b1100 ? {8'b0,IMM}:OPCODE=='b1000 ? PCC:'bz)));
		

always @(posedge clk) begin
	if(rst == 1) begin
		PC <= 0;
		stage <= 0;
		RW_reg <= 1;
	end
	else begin
		if(stage == 0)begin
			INST <= ID;
			stage <= 1;
		end
		else if(stage == 1)begin
			if(OPCODE[3]==0)begin
				FUA<=ABUS;
				FUB<=BBUS;
			end
			if(OPCODE[3:1]=='b101)begin
				LSUA<=ABUS;
				LSUB<=BBUS;
			end
			if(OPCODE[3:0]=='b1000||(OPCODE[3:0]=='b1001&&FLAG==1))
				PCI <= BBUS;
			else	PCI <= PC + 1;
			
			stage <= 2;
		end
		else if(stage == 2)begin
			if(OPCODE[3]==0)begin
				case (OPCODE[3:0])
					'b0000:FUC<=FUA+FUB;
					'b0001:FUC<=FUA-FUB;
					'b0010:FUC<=FUA>>FUB;
					'b0011:FUC<=FUA<<FUB;
					'b0100:FUC<=FUA|FUB;
					'b0101:FUC<=FUA&FUB;
					'b0110:FUC<=~FUA;
					'b0111:FUC<=FUA^FUB;
				endcase
			end
			
			if(OPCODE[3:1]=='b101)begin
				if(OPCODE[0]==0)begin
					RW_reg <= 0;
				end
				else begin
					RW_reg <= 1;
					LSUC <= DD;
				end
			end
			if(OPCODE[3:0]=='b1000)
				PCC <= PC+1;
			stage <= 3;
		end
		else if (stage == 3)begin
			RF[OPR1]<=CBUS;
			PC <= PCI;
			stage <= 0;
			if(OPCODE[3]==0)begin
				if(CBUS==0)FLAG<=1;
				else FLAG<=0;
			end
			
		end
	end
end
endmodule


