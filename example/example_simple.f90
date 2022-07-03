program example_simple
  use mod_kinds, only: ik, rk
  use mod_network, only: network_type
  implicit none
  type(network_type) :: net
  real(rk), allocatable :: input(:), output(:)
  integer :: i
  net = network_type([3_ik, 5_ik, 2_ik])
  input = [0.2_rk, 0.4_rk, 0.6_rk]
  output = [0.123456_rk, 0.246802_rk]
  do i = 1, 500
    call net % train(input, output, eta=1.0_rk)
    print *, 'Iteration: ', i, 'Output:', net % output(input)
  end do
end program example_simple
