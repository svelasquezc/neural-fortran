program test_network_sync
  use mod_kinds, only: ik
  use mod_network, only: network_type
  implicit none
  type(network_type) :: net

  net = network_type([5_ik, 3_ik, 2_ik])
  print *, this_image(), net % layers(1) % w

end program test_network_sync
