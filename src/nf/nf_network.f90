module nf_network

  !! This module provides the network type to create new models.

  use nf_layer, only: layer
  use nf_optimizers, only: sgd

  implicit none

  private
  public :: network

  type :: network

    type(layer), allocatable :: layers(:)

  contains

    procedure :: backward
    procedure :: print_info
    procedure :: train
    procedure :: update

    procedure, private :: forward_1d
    procedure, private :: forward_3d
    procedure, private :: output_1d
    procedure, private :: output_3d

    generic :: forward => forward_1d, forward_3d
    generic :: output => output_1d, output_3d

  end type network

  interface network
    module function network_cons(layers) result(res)
      !! Create a new `network` instance.
      type(layer), intent(in) :: layers(:)
        !! Input array of layer instances;
        !! the first element must be an input layer.
      type(network) :: res
        !! An instance of the `network` type
    end function network_cons
  end interface network

  interface forward

    pure module subroutine forward_1d(self, input)
      !! Apply a forward pass through the network.
      !!
      !! This changes the state of layers on the network.
      !! Typically used only internally from the `train` method,
      !! but can be invoked by the user when creating custom optimizers.
      !!
      !! This specific subroutine is for 1-d input data.
      class(network), intent(in out) :: self
        !! Network instance
      real, intent(in) :: input(:)
        !! 1-d input data
    end subroutine forward_1d

    pure module subroutine forward_3d(self, input)
      !! Apply a forward pass through the network.
      !!
      !! This changes the state of layers on the network.
      !! Typically used only internally from the `train` method,
      !! but can be invoked by the user when creating custom optimizers.
      !!
      !! This specific subroutine is for 3-d input data.
      class(network), intent(in out) :: self
        !! Network instance
      real, intent(in) :: input(:,:,:)
        !! 3-d input data
    end subroutine forward_3d

  end interface forward

  interface output

    module function output_1d(self, input) result(res)
      !! Return the output of the network given the input 1-d array.
      class(network), intent(in out) :: self
        !! Network instance
      real, intent(in) :: input(:)
        !! Input data
      real, allocatable :: res(:)
        !! Output of the network
    end function output_1d

    module function output_3d(self, input) result(res)
      !! Return the output of the network given the input 3-d array.
      class(network), intent(in out) :: self
        !! Network instance
      real, intent(in) :: input(:,:,:)
        !! Input data
      real, allocatable :: res(:)
        !! Output of the network
    end function output_3d

  end interface output

  interface

    pure module subroutine backward(self, output)
      !! Apply one backward pass through the network.
      !! This changes the state of layers on the network.
      !! Typically used only internally from the `train` method,
      !! but can be invoked by the user when creating custom optimizers.
      class(network), intent(in out) :: self
        !! Network instance
      real, intent(in) :: output(:)
        !! Output data
    end subroutine backward

    module subroutine print_info(self)
      !! Prints a brief summary of the network and its layers to the screen.
      class(network), intent(in) :: self
        !! Network instance
    end subroutine print_info

    module subroutine train(self, input_data, output_data, batch_size, &
                            epochs, optimizer)
      class(network), intent(in out) :: self
        !! Network instance
      real, intent(in) :: input_data(:,:)
        !! Input data to train on;
        !! first dimension contains a single sample
        !! and its size must match the size of the input layer.
      real, intent(in) :: output_data(:,:)
        !! Output data to train on;
        !! first dimension contains a single sample
        !! and its size must match the size of the input layer.
      integer, intent(in) :: batch_size
        !! Batch size to use.
        !! Set to 1 for a pure stochastic gradient descent.
        !! Set to `size(input_data, dim=2)` for a batch gradient descent.
      integer, intent(in) :: epochs
        !! Number of epochs to run
      type(sgd), intent(in) :: optimizer
        !! Optimizer instance; currently this is an `sgd` optimizer type
        !! and it will be made to be a more general optimizer type.
    end subroutine train

    module subroutine update(self, learning_rate)
      !! Update the weights and biases on all layers using the stored
      !! gradients (from backward passes) on those layers, and flush those
      !! same stored gradients to zero.
      !! This changes the state of layers on the network.
      !! Typically used only internally from the `train` method,
      !! but can be invoked by the user when creating custom optimizers.
      class(network), intent(in out) :: self
        !! Network instance
      real, intent(in) :: learning_rate
        !! Learning rate to use; must be > 0.
    end subroutine update

  end interface

end module nf_network
