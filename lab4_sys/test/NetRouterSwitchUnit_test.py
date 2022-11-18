#=========================================================================
# NetRouterSwitchUnit_test
#=========================================================================

import pytest

from pymtl3 import *
from pymtl3.stdlib.test_utils import mk_test_case_table, run_sim
from pymtl3.stdlib.stream import StreamSourceFL, StreamSinkFL

from lab4_sys.NetMsg import mk_net_msg
from lab4_sys.NetRouterSwitchUnit import NetRouterSwitchUnit

#-------------------------------------------------------------------------
# Message Types
#-------------------------------------------------------------------------

NetMsgType = mk_net_msg( 32 )

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Component ):

  def construct( s ):

    # Instantiate models

    s.src0 = StreamSourceFL( NetMsgType )
    s.src1 = StreamSourceFL( NetMsgType )
    s.src2 = StreamSourceFL( NetMsgType )

    s.sunit = NetRouterSwitchUnit( 44 )

    s.sink = StreamSinkFL  ( NetMsgType )

    # Connect

    s.src0.ostream  //= s.sunit.istream0
    s.src1.ostream  //= s.sunit.istream1
    s.src2.ostream  //= s.sunit.istream2
    s.sunit.ostream //= s.sink.istream

  def done( s ):
    return s.src0.done() and s.src1.done() and s.src2.done() and s.sink.done()

  def line_trace( s ):
    return s.src0.line_trace()  + "|" + \
           s.src1.line_trace()  + "|" + \
           s.src2.line_trace()  + " > (" + \
           s.sunit.line_trace() + ") > " + \
           s.sink.line_trace()

#-------------------------------------------------------------------------
# test
#-------------------------------------------------------------------------

def test_basic( cmdline_opts ):

  th = TestHarness()

  msgs = [
    #           dest src  opaq  payload
    NetMsgType( 0,   0,   0x10, 0x10101010 ),
    NetMsgType( 0,   1,   0x11, 0x11111111 ),
    NetMsgType( 0,   2,   0x12, 0x12121212 ),
  ]

  th.set_param("top.src0.construct", msgs=[ m for m in msgs if m.src == 0 ] )
  th.set_param("top.src1.construct", msgs=[ m for m in msgs if m.src == 1 ] )
  th.set_param("top.src2.construct", msgs=[ m for m in msgs if m.src == 2 ] )
  th.set_param("top.sink.construct", msgs=msgs  )

  th.elaborate()

  run_sim( th, cmdline_opts, duts=['sunit'] )

#-------------------------------------------------------------------------
# Test Cases: Very Simple
#-------------------------------------------------------------------------

one = [
  #           dest src  opaq  payload
  NetMsgType( 0,   0,   0x10, 0x10101010 ),
]

three = [
  #           dest src  opaq  payload
  NetMsgType( 3,   0,   0x10, 0x10101010 ),
  NetMsgType( 2,   1,   0x11, 0x11111111 ),
  NetMsgType( 1,   2,   0x12, 0x12121212 ),
]

three_diff_dest = [
  #           dest src  opaq  payload
  NetMsgType( 3,   0,   0x10, 0x10101010 ),
  NetMsgType( 2,   1,   0x11, 0x11111111 ),
  NetMsgType( 1,   2,   0x12, 0x12121212 ),
]

#-------------------------------------------------------------------------
# Test Cases: Stream from One Port
#-------------------------------------------------------------------------

stream_from_src0 = []
for i in range(20):
  msg = NetMsgType( dest=0, src=0, opaque=i, payload=i )
  stream_from_src0.append( msg )

stream_from_src1 = []
for i in range(20):
  msg = NetMsgType( dest=0, src=1, opaque=i, payload=i )
  stream_from_src1.append( msg )

stream_from_src2 = []
for i in range(20):
  msg = NetMsgType( dest=0, src=2, opaque=i, payload=i )
  stream_from_src2.append( msg )

#-------------------------------------------------------------------------
# Test Cases: Stream from All Ports
#-------------------------------------------------------------------------

stream_from_all = []

for i in range(16):
  msg = NetMsgType( dest=0, src=0, opaque=0x00+i, payload=0x0000+i )
  stream_from_all.append(msg)

for i in range(16):
  msg = NetMsgType( dest=0, src=1, opaque=0x00+i, payload=0x0000+i )
  stream_from_all.append(msg)

for i in range(16):
  msg = NetMsgType( dest=0, src=2, opaque=0x00+i, payload=0x0000+i )
  stream_from_all.append(msg)

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                               "msgs           src_delay sink_delay delay_mode"),
  [ "one",                         one,                  0,  0,  'fixed'  ],
  [ "three",                       three,                0,  0,  'fixed'  ],
  [ "three_diff_dest",             three_diff_dest,      0,  0,  'fixed'  ],
  [ "stream_from_src0",            stream_from_src0,     0,  0,  'fixed'  ],
  [ "stream_from_src1",            stream_from_src1,     0,  0,  'fixed'  ],
  [ "stream_from_src2",            stream_from_src2,     0,  0,  'fixed'  ],
  [ "stream_from_all",             stream_from_all,      0,  0,  'fixed'  ],

  [ "stream_from_src0_fixed_0x2",  stream_from_src0,     0,  2,  'fixed'  ],
  [ "stream_from_src0_fixed_2x0",  stream_from_src0,     2,  0,  'fixed'  ],
  [ "stream_from_src1_fixed_0x2",  stream_from_src1,     0,  2,  'fixed'  ],
  [ "stream_from_src1_fixed_2x0",  stream_from_src1,     2,  0,  'fixed'  ],
  [ "stream_from_src2_fixed_0x2",  stream_from_src2,     0,  2,  'fixed'  ],
  [ "stream_from_src2_fixed_2x0",  stream_from_src2,     2,  0,  'fixed'  ],
  [ "stream_from_all_fixed_0x2",   stream_from_all,      0,  2,  'fixed'  ],

  [ "stream_from_src0_rand_delay", stream_from_src0,     3, 20,  'random' ],
  [ "stream_from_src1_rand_delay", stream_from_src1,     3, 20,  'random' ],
  [ "stream_from_src2_rand_delay", stream_from_src2,     3, 20,  'random' ],
  [ "stream_from_all_rand_delay",  stream_from_all,      0, 20,  'random' ],
])

#-------------------------------------------------------------------------
# test
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test_basic( test_params, cmdline_opts ):

  th = TestHarness()

  th.set_param("top.src0.construct",
    msgs                = [ m for m in test_params.msgs if m.src == 0 ],
    interval_delay_mode = test_params.delay_mode,
    initial_delay       = test_params.src_delay,
    interval_delay      = test_params.src_delay )

  th.set_param("top.src1.construct",
    msgs                = [ m for m in test_params.msgs if m.src == 1 ],
    interval_delay_mode = test_params.delay_mode,
    initial_delay       = test_params.src_delay,
    interval_delay      = test_params.src_delay )

  th.set_param("top.src2.construct",
    msgs                = [ m for m in test_params.msgs if m.src == 2 ],
    interval_delay_mode = test_params.delay_mode,
    initial_delay       = test_params.src_delay,
    interval_delay      = test_params.src_delay )

  th.set_param("top.sink.construct",
    msgs                = test_params.msgs,
    interval_delay_mode = test_params.delay_mode,
    initial_delay       = test_params.sink_delay,
    interval_delay      = test_params.sink_delay )

  th.elaborate()

  run_sim( th, cmdline_opts, duts=['sunit'] )

