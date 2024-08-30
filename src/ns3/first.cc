/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation;
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include "ns3/applications-module.h"
#include "ns3/core-module.h"
#include "ns3/internet-module.h"
#include "ns3/network-module.h"
#include "ns3/point-to-point-module.h"

// Default Network Topology
//
//       10.1.1.0
// n0 -------------- n1
//    point-to-point
//

using namespace ns3;

NS_LOG_COMPONENT_DEFINE("FirstScriptExample");

int
main(int argc, char* argv[])
{
    // Collects arguments from NS3 commands
    CommandLine cmd(__FILE__);
    cmd.Parse(argc, argv);

    // Sets time resolution: Can only be done once, as memory is freed
    // after this function is called
    Time::SetResolution(Time::NS);
    
    // Enable logging at the INFO level
    LogComponentEnable("UdpEchoClientApplication", LOG_LEVEL_INFO);
    LogComponentEnable("UdpEchoServerApplication", LOG_LEVEL_INFO);

    // Create two NS3 nodes (End user devices)
    NodeContainer nodes;
    nodes.Create(2);

    // Declare PointToPoint Helper object on the stack
    PointToPointHelper pointToPoint;
    
    // Set DataRate and Delay of P2P link
    pointToPoint.SetDeviceAttribute("DataRate", StringValue("5Mbps"));
    pointToPoint.SetChannelAttribute("Delay", StringValue("2ms"));

    // Apply P2P configuration to test nodes via device and node objects
    NetDeviceContainer devices;
    devices = pointToPoint.Install(nodes);

    // Install a protocol stack on each P2P node via stack and node objects
    // Allows OSI configuration
    InternetStackHelper stack;
    stack.Install(nodes);

    // Set IPv4 Addressing between device and address objects
    // Mimics DHCP given a net addr and subnet mask
    Ipv4AddressHelper address;
    address.SetBase("10.1.1.0", "255.255.255.0");

    // Apply addressing via the interfaces, address, and devices objects
    Ipv4InterfaceContainer interfaces = address.Assign(devices);

    // Next, we declare a UdpEchoServer application on the second node 
    // This line is not the application itself, but a helper object used to set its
    // initialization attributes: It is a constructor object
    UdpEchoServerHelper echoServer(9);

    // Install method leveraged to instantiate the actual echo server application
    // This works by inputing a single node container. The nodes.get method returns
    // a pointer to the node at index 1. Leverages zero based indexing. 
    ApplicationContainer serverApps = echoServer.Install(nodes.Get(1));
    serverApps.Start(Seconds(1.0));
    serverApps.Stop(Seconds(10.0));


    // Very similar framework to establish a UdpEchoClient application on the
    // first node. Note there is a bit of configuration for the client.
    UdpEchoClientHelper echoClient(interfaces.GetAddress(1), 9);
    echoClient.SetAttribute("MaxPackets", UintegerValue(1));
    echoClient.SetAttribute("Interval", TimeValue(Seconds(1.0)));
    echoClient.SetAttribute("PacketSize", UintegerValue(1024));

    // Set the start time of the client one second 
    // after the start time of the server.
    ApplicationContainer clientApps = echoClient.Install(nodes.Get(0));
    clientApps.Start(Seconds(2.0));
    clientApps.Stop(Seconds(10.0));
    
    // Schedule an explicit simulation stop at 11 seconds
    // This command is necessary when there is a self-sustaining event
    // within your program (AKA recurring event). Some example NS3 modules
    // which contain recurring events include:
    // 1. FlowMonitor - Periodic check for lost packets
    // 2. RIPng - Periodic broadcast of routing tables 
    // 
    // Within the context of this sample program, this is not necessary because
    // the example simulation naturally ends at 10 seconds
    Simulator::Stop(Seconds(11.0));
    
    // Start the NS3 simulation
    Simulator::Run();
    
    // Destruct NS3 and destroy/free all created objects
    Simulator::Destroy();
    return 0;
}
