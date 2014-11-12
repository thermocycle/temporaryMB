within Components.Units.HeatExchangers.MovingBoundary;
model Cell_SuperHeated
  extends Cell_OnePhase_Base;

  input Modelica.SIunits.Length l_in = 2;

equation
  //h_a  = h_v;
  //dhdt_a = dhdp_v*dpdt;
  rho_a  = Medium.density_ph(p_a,h_a);
  dzdt_a = 0;

  ll = l_in;

  //h_b  = is calculated
  dhdt_b = der(outFlow.h_outflow);
  rho_b  = Medium.density_ph(p_b,h_b);
  dzdt_b = dldt;

end Cell_SuperHeated;
