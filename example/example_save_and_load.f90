program example_save_and_load

  use mod_kinds, only: ik,rk
  use mod_network, only: network_type
  implicit none

  type(network_type) :: net1, net2
  real(rk), allocatable :: input(:), output(:)
  integer :: i

  net1 = network_type([3_ik, 5_ik, 2_ik])

  input = [0.2_rk, 0.4_rk, 0.6_rk]
  output = [0.123456_rk, 0.246802_rk]

  ! train network 1
  do i = 1, 500
    call net1 % train(input, output, eta=1.0_rk)
  end do

  ! save network 1 to file
  call net1 % save('my_simple_net.txt')

  ! load network 2 from file 
  !net2 = network_type([3, 5, 2])
  call net2 % load('my_simple_net.txt')
  call net2 % set_activation('sigmoid')

  print *, 'Network 1 output: ', net1 % output(input) 
  print *, 'Network 2 output: ', net2 % output(input)
  print *, 'Outputs match: ', all(net1 % output(input) == net2 % output(input))

end program example_save_and_load
