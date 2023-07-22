// Create 's'
s = poly(0,'s')

// System parameters
m = 10;
k = 0.5;

// System transfer function
G = 1/(s*(m*s+k));

// Weight functions
W1 = 100/(s+1);
W2 = 0.1*s/(s+1);
W3 = W2;

// Augmented plant transfer function
// w = [r; d]
// z = [W1*e; W2*u; W3*y]
// v = e
// e = r - y
// [z; v] = P*[w; u]
P = syslin('c',[W1, -W1*G, -W1*G; 0, 0, W2; 0, W3*G, W3*G; 1, -G, -G]);

// H Infinity controller K
[K,ro] = h_inf(P,[1,1],0,10,100);

// Define the name of the Xcos diagram to be loaded
scheme = "H_inf_pos_control.zcos";

// Load the Xcos diagram
importXcosDiagram(scheme);

// Define a string containing a list of parameters and their values
ctx = ["m = 10; k = 0.5; stp = 1; Fd = 0.2; std_noise = 0;"];

// Set the context of the Xcos diagram to the values defined in `ctx`
scs_m.props.context = ctx;

// Simulate the Xcos diagram
xcos_simulate(scs_m, 4);

show_window(2);

// Create a subplot and plot the output `u_out` against time `u_out.time`
subplot(212);
h = plot(u_out.time, u_out.values, 'b-', 'LineWidth',4);
ax=gca();
set(gca(),"grid",[1 1]);
xlabel('t[s]', 'font_style', 'times bold', 'font_size', 4);
ylabel('F [N]', 'font_style', 'times bold', 'font_size', 4);

// Create another subplot and plot three outputs: `stp_out`, `z_id`, and `z_out`
subplot(211);
h = plot(stp_out.time, stp_out.values, 'r-', z_out.time, z_out.values, 'b-', 'LineWidth',4);
l = legend("Setpoint", "Response");
l.font_size = 4;
ax=gca();
set(gca(),"grid",[1 1]);
xlabel('t[s]', 'font_style', 'times bold', 'font_size', 4);
ylabel('Position [m]', 'font_style', 'times bold', 'font_size', 4);

