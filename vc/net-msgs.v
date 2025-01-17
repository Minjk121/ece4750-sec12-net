//========================================================================
// net-msgs : Network Messages
//========================================================================
// Network messages are split into two parts: a fixed header, and a
// variable-width payload. The header provides source and destination
// information for a 4-node network, along with an 8-bit opaque field.
// The payload is sent as an additional signal, sent at the same time as
// the header.
//
// This is the format defined by the header struct
//
// 11   10 9    8 7      0 
// +------+------+--------+
// | dest | src  | opaque |
// +------+------+--------+
//

`ifndef VC_NET_MSGS_V
`define VC_NET_MSGS_V

`include "vc/trace.v"

//-------------------------------------------------------------------------
// Message defines
//-------------------------------------------------------------------------

typedef struct packed {
  logic [1:0] dest;
  logic [1:0] src;
  logic [7:0] opaque;
} net_hdr_t;

//------------------------------------------------------------------------
// Trace message
//------------------------------------------------------------------------

module vc_NetMsgTrace
#(
  parameter p_msg_nbits = 44
)
(
  input  logic                   clk,
  input  logic                   reset,
  input  logic [p_msg_nbits-1:0] msg,
  input  logic                   val,
  input  logic                   rdy
);

  // Extract fields

  logic [1:0]    dest;
  logic [1:0]    src;
  logic [7:0]    opaque;

  assign dest   = msg[p_msg_nbits-1:p_msg_nbits-2];
  assign src    = msg[p_msg_nbits-3:p_msg_nbits-4];
  assign opaque = msg[p_msg_nbits-5:p_msg_nbits-12];

  // Line tracing

  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    $sformat( str, "%x>%x:%x", src, dest, opaque );

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

`endif /* VC_NET_MSGS_V */
