#=========================================================================
# NetMsg.py
#=========================================================================

from pymtl3 import *

def mk_net_msg( payload_nbits ):

  @bitstruct
  class NetMsg:
    dest    : Bits2
    src     : Bits2
    opaque  : Bits8
    payload : mk_bits( payload_nbits )

    def __str__( self ):
      return "{}>{}:{}".format(
        self.src,
        self.dest,
        self.opaque
      )

  return NetMsg

