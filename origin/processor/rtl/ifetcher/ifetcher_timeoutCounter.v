module ifetcher_timeoutCounter #(CW=8) (
	iClk,
	iResetn,
	iCountEn,
	iCountDone,
	oTimeoutFatal,
	oCounter
);

	output [CW-1:0] oCounter;
	input iClk,iResetn;
	// iCountDone is a pulse, iCountEn is a level, enabled only when its value is 1.
	input iCountEn,iCountDone;
	output oTimeoutFatal;
	reg [CW-1:0] rCounter;

	// this fatal is a pulse
	assign oTimeoutFatal=(&rCounter)? 1'b1 : 1'b0;

	assign oCounter=rCounter;
	always @(posedge iClk or negedge iResetn) begin
		if (!iResetn) begin
			rCounter<={CW{1'b0}};
		end else begin
			case ({iCountDone,iCountEn})
				2'b01: rCounter<=rCounter+1'b1;
				2'b10: rCounter<={CW{1'b0}};
				default: rCounter<=rCounter;
			endcase
		end
	end


endmodule