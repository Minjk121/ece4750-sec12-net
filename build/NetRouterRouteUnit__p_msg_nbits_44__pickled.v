//-------------------------------------------------------------------------
// NetRouterRouteUnit__p_msg_nbits_44.v
//-------------------------------------------------------------------------
// This file is generated by PyMTL SystemVerilog translation pass.

// PyMTL BitStruct NetMsg__dest_2__src_2__opaque_8__payload_32 Definition
typedef struct packed {
  logic [1:0] dest;
  logic [1:0] src;
  logic [7:0] opaque;
  logic [31:0] payload;
} NetMsg__dest_2__src_2__opaque_8__payload_32;

// PyMTL VerilogPlaceholder NetRouterRouteUnit Definition
// At /home/mk2592/ECE4750/tuto/sec12/lab4_sys/NetRouterRouteUnit.py

//***********************************************************
// Pickled source file of placeholder NetRouterRouteUnit__p_msg_nbits_44
//***********************************************************

//-----------------------------------------------------------
// Dependency of placeholder NetRouterRouteUnit
//-----------------------------------------------------------

`ifndef NETROUTERROUTEUNIT
`define NETROUTERROUTEUNIT

// The source code below are included because they are specified
// as the v_libs Verilog placeholder option of component NetRouterRouteUnit__p_msg_nbits_44.

// If you get a duplicated def error from files included below, please
// make sure they are included either through the v_libs option or the
// explicit `include statement in the Verilog source code -- if they
// appear in both then they will be included twice!


// End of all v_libs files for component NetRouterRouteUnit__p_msg_nbits_44

`line 1 "lab4_sys/NetRouterRouteUnit.v" 0
//========================================================================
// Network Router Route Unit
//========================================================================

`ifndef LAB4_SYS_NET_ROUTER_ROUTE_UNIT_V
`define LAB4_SYS_NET_ROUTER_ROUTE_UNIT_V

`line 1 "vc/net-msgs.v" 0
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

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 22 "vc/net-msgs.v" 0

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

`line 9 "lab4_sys/NetRouterRouteUnit.v" 0
`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 10 "lab4_sys/NetRouterRouteUnit.v" 0

module lab4_sys_NetRouterRouteUnit
#(
  parameter p_msg_nbits = 44
)
(
  input  logic                   clk,
  input  logic                   reset,

  // Router id (which router is this in the network?)

  input  logic     [1:0]         router_id,

  // Input stream

  input  logic [p_msg_nbits-1:0] istream_msg,
  input  logic                   istream_val,
  output logic                   istream_rdy,

  // Output stream 0

  output logic [p_msg_nbits-1:0] ostream0_msg,
  output logic                   ostream0_val,
  input  logic                   ostream0_rdy,

  // Output stream 0

  output logic [p_msg_nbits-1:0] ostream1_msg,
  output logic                   ostream1_val,
  input  logic                   ostream1_rdy,

  // Output stream 0

  output logic [p_msg_nbits-1:0] ostream2_msg,
  output logic                   ostream2_val,
  input  logic                   ostream2_rdy
);

  logic [1:0] istream_msg_dest;
  assign istream_msg_dest = istream_msg[p_msg_nbits-1:p_msg_nbits-2];

  assign ostream0_msg = istream_msg;
  assign ostream1_msg = istream_msg;
  assign ostream2_msg = istream_msg;

  always_comb begin

    istream_rdy  = 0;
    ostream0_val = 0;
    ostream1_val = 0;
    ostream2_val = 0;

    if ( istream_val ) begin
      if ( istream_msg_dest == 0 ) begin
        istream_rdy = ostream0_rdy;
        ostream0_val = 1;
      end
      else if ( istream_msg_dest == 1 ) begin
        istream_rdy = ostream1_rdy;
        ostream1_val = 1;
      end
      else if ( istream_msg_dest == 2 ) begin
        istream_rdy = ostream2_rdy;
        ostream2_val = 1;
      end
    end

  end

  //----------------------------------------------------------------------
  // Line Tracing
  //----------------------------------------------------------------------

  `ifndef SYNTHESIS

  logic [`VC_TRACE_NBITS-1:0] str;
  `VC_TRACE_BEGIN
  begin

    if ( istream_val && istream_rdy ) begin
      $sformat( str, "%d", istream_msg_dest );
      vc_trace.append_str( trace_str, str );
    end
    else
      vc_trace.append_str( trace_str, " " );

  end
  `VC_TRACE_END

  `endif /* SYNTHESIS */

endmodule

`endif /* NET_ROUTER_ROUTE_UNIT_V */

`endif /* NETROUTERROUTEUNIT */
//-----------------------------------------------------------
// Wrapper of placeholder NetRouterRouteUnit__p_msg_nbits_44
//-----------------------------------------------------------

`ifndef NETROUTERROUTEUNIT__P_MSG_NBITS_44
`define NETROUTERROUTEUNIT__P_MSG_NBITS_44

module NetRouterRouteUnit__p_msg_nbits_44
(
  input logic [1-1:0] clk ,
  input logic [1-1:0] reset ,
  input logic [4-1:0] router_id ,
  input logic [44-1:0] istream_msg ,
  output logic [1-1:0] istream_rdy ,
  input logic [1-1:0] istream_val ,
  output logic [44-1:0] ostream0_msg ,
  input logic [1-1:0] ostream0_rdy ,
  output logic [1-1:0] ostream0_val ,
  output logic [44-1:0] ostream1_msg ,
  input logic [1-1:0] ostream1_rdy ,
  output logic [1-1:0] ostream1_val ,
  output logic [44-1:0] ostream2_msg ,
  input logic [1-1:0] ostream2_rdy ,
  output logic [1-1:0] ostream2_val 
);
  lab4_sys_NetRouterRouteUnit
  #(
    .p_msg_nbits( 44 )
  ) v
  (
    .clk( clk ),
    .reset( reset ),
    .router_id( router_id ),
    .istream_msg( istream_msg ),
    .istream_rdy( istream_rdy ),
    .istream_val( istream_val ),
    .ostream0_msg( ostream0_msg ),
    .ostream0_rdy( ostream0_rdy ),
    .ostream0_val( ostream0_val ),
    .ostream1_msg( ostream1_msg ),
    .ostream1_rdy( ostream1_rdy ),
    .ostream1_val( ostream1_val ),
    .ostream2_msg( ostream2_msg ),
    .ostream2_rdy( ostream2_rdy ),
    .ostream2_val( ostream2_val )
  );
endmodule

`endif /* NETROUTERROUTEUNIT__P_MSG_NBITS_44 */
