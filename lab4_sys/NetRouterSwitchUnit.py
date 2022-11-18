#=========================================================================
# NetRouterSwitchUnit PyMTL3 Wrapper
#=========================================================================

from pymtl3 import *
from pymtl3.passes.backends.verilog import *
from pymtl3.stdlib.stream.ifcs import IStreamIfc, OStreamIfc

from lab4_sys.NetMsg import mk_net_msg

class NetRouterSwitchUnit( VerilogPlaceholder, Component ):
  def construct( s, p_msg_nbits=44 ):

    NetMsgType = mk_net_msg( p_msg_nbits-12 )

    s.istream0  = IStreamIfc( NetMsgType )
    s.istream1  = IStreamIfc( NetMsgType )
    s.istream2  = IStreamIfc( NetMsgType )
    s.ostream   = OStreamIfc( NetMsgType )

