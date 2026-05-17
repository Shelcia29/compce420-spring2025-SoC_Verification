Title: README.txt
------------------------------------------------------------------------------------------------
GPIO Testbench Documentation: This documentation provides design intent of the gpio teshbench.
------------------------------------------------------------------------------------------------
The GPIO testbench is a block-level UVM testbench designed to verify the behavior of the Pulpino GPIO adapter.

## Environment Overview (env)
The UVM environment that contains the gpio agent, aph agent, scoreboard, coverage monitor, and connects to the GPIO device under test (DUT). It consists of the following components:
1. scoreboard
2. gpio and apb configuration
3. coverage monitor
3. apb agent
4. gpio agent

## Agent Overview (gpio_agent)
The agent that handles the communication between the testbench and the DUT. It contains a driver, monitor, and sequencer. The agent monitor connects to the scoreboard through coverage monitor.

## Agent Overview (apb_agent)
The agent that handles the communication between the testbench and the DUT. It contains a driver, monitor, and sequencer. The agent monitor connects to the scoreboard. A basic scoreboard that monitors the GPIO output and checks the received values.

## Sequences Overview
The sequence toggles the GPIO signal. It starts by setting the signal to high, then to low, and repeats. This sequence is applied to the DUT through the agent.

## Test Overview
The test simply toggles the GPIO pins between high and low values to verify that the GPIO adapter responds to the changes. It contains test files of the following: gpio input and output, gpio registers and gpio base test.

## Register Model Overview
It contains the gpio register package.
gpio_reg_block_map
│
├── Address: 'h0 → gpio_in (RO - Read-Only)
├── Address: 'h4 → gpio_out (RW - Read-Write)
├── Address: 'h8 → gpio_oe (RW - Read-Write)
├── Address: 'hc → gpio_inte (RW - Read-Write)
├── Address: 'h10 → gpio_ptrig (RW - Read-Write)
├── Address: 'h14 → gpio_aux (RW - Read-Write)
├── Address: 'h18 → gpio_ctrl (RW - Read-Write)
├── Address: 'h1c → gpio_ints (RW - Read-Write)
├── Address: 'h20 → gpio_eclk (RW - Read-Write)
└── Address: 'h24 → gpio_nec (RW - Read-Write)

## Instructions to Compile and Run the Testbench
1. **Set up the environment**: Ensure that you have the UVM library properly set up in your simulation environment.
2. **Compile the testbench**: Use the following command to compile the UVM testbench (with your simulator, e.g., VCS or Questa):

   ```bash
   vcs -full64 -sv -f filelist.f -debug_pp

