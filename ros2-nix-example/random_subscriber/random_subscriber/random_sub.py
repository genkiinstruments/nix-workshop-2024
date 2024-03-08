import rclpy
from rclpy.node import Node
from random_pubsub_interfaces.msg import RandomRange

from std_msgs.msg import Int32

class RandomSubscriber(Node):
    def __init__(self):
        super().__init__('random_subscriber')
        self.declare_parameter('min_interest', -1)
        self.declare_parameter('max_interest', 3)

        self.min_interest = self.get_parameter('min_interest').get_parameter_value().integer_value
        self.max_interest = self.get_parameter('max_interest').get_parameter_value().integer_value

        self.subscription = self.create_subscription(
            RandomRange,
            'random_number',
            self.listener_callback,
            10)
        self.subscription  # prevent unused variable warning

    def listener_callback(self, msg):
        if msg.data >= self.min_interest and msg.data <= self.max_interest:
            output_msg = "Received {} that is in range <{}, {}>".format(msg.data,
                                                                        self.min_interest,
                                                                        self.max_interest)
            self.get_logger().info(output_msg)

def main(args=None):
    rclpy.init(args=args)

    random_subscriber = RandomSubscriber()
    rclpy.spin(random_subscriber)

    random_subscriber.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
