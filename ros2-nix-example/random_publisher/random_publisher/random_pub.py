import rclpy
from rclpy.node import Node

from random_pubsub_interfaces.srv import SetInt32
from random_pubsub_interfaces.msg import RandomRange
from std_msgs.msg import Int32
import random

class RandomPublisher(Node):

    def __init__(self):
        super().__init__('random_publisher')
        self.publisher_ = self.create_publisher(RandomRange, 'random_number', 1)

        self.declare_parameter('start_number', -5)
        self.declare_parameter('stop_number', 10)
        self.declare_parameter('timer_period_s', 0.5)

        timer_period = self.get_parameter('timer_period_s').get_parameter_value().double_value
        self.start_number = self.get_parameter('start_number').get_parameter_value().integer_value
        self.stop_number = self.get_parameter('stop_number').get_parameter_value().integer_value
        self.start_number_srv = self.create_service(SetInt32, '~/set_start_number', self.set_start_number_cb)
        self.stop_number_srv = self.create_service(SetInt32, '~/set_stop_number', self.set_stop_number_cb)


        self.timer = self.create_timer(timer_period, self.timer_callback)

    def set_start_number_cb(self, request, response):
        if request.data > self.stop_number:
            response.success = False
            response.message = "Can't set start number that is higher than stop number"
            return response
        self.start_number = request.data
        response.success = True
        response.message = "Start number successfully adjusted"
        return response

    def set_stop_number_cb(self, request, response):
        if request.data < self.start_number:
            response.success = False
            response.message = "Can't set stop number that is lower than start number"
            return response
        self.stop_number = request.data
        response.success = True
        response.message = "Stop number successfully adjusted"
        return response

    def timer_callback(self):
        msg = RandomRange()
        msg.data = random.randint(self.start_number, self.stop_number)
        msg.start_number = self.start_number
        msg.stop_number = self.stop_number
        self.publisher_.publish(msg)

def main(args=None):
    rclpy.init(args=args)

    random_publisher = RandomPublisher()

    rclpy.spin(random_publisher)

    random_publisher.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
