within Components.Units.HeatExchangers.MovingBoundary;
model Cell_SubCooled
  extends Cell_OnePhase_Base;
  //
  //
  //
equation
  //h_a  = comes from connector
  //dhdt_a = der(inFlow.h_outflow);
  rho_a  = Medium.density_ph(p_a,h_a);
  dzdt_a = 0;

    h_b  = h_l;
  dhdt_b = dhdp_l*dpdt;
  rho_b  = rho_l;
  dzdt_b = dldt;

end Cell_SubCooled;
