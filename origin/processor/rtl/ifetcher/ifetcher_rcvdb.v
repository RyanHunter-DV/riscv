module ifetcher_rcvdb #(IW=32) (
	iClk,
	iResetn,
	iClear,
	iWE,
	iWD,
	iRE,
	oRD,
	oEmpty,
	oFull
);

	input iClk,iResetn;
	input iClear,iWE,iRE;
	output oEmpty,oFull;
	input  [IW*4-1:0] iWD;
	output [IW*4-1:0] oRD;
	wire resetN;

	reg[IW*4-1:0] mem[7:0];
	reg[2:0] rPtr,wPtr;

	assign oEmpty=(rPtr==wPtr)? 1'b1:1'b0;
	assign oFull=(wPtr+1==rPtr)? 1'b1:1'b0;
	assign oRD=mem[rPtr];
	assign resetN=iResetn&(~iClear);

	always @(posedge iClk or negedge resetN) begin
		if (!resetN) begin
			rPtr<=3'h0;
			wPtr<=3'h0;
		end else begin
			if (iWE) begin
				mem[wPtr]<=iWD;
				wPtr<=wPtr+1'b1;
			end
			if (iRE) begin
				rPtr<=rPtr+1'b1;
			end
		end
	end

endmodule