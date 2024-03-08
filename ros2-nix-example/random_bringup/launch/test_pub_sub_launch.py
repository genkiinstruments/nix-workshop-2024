from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='random_publisher',
            executable='random_pub',
            name='random_publisher',
            output="screen",
            parameters=[
                {'start_number': 100},
                {'stop_number': 200},
                {'timer_period_s': 0.02}
            ]
        ),
        Node(
            package='random_subscriber',
            executable='random_sub',
            name='random_subscriber',
            output='screen',
            parameters=[
                {'min_interest': 150},
                {'max_interest': 170}
            ]
        )
    ])
