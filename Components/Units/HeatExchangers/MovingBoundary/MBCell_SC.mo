within Components.Units.HeatExchangers.MovingBoundary;
model MBCell_SC "Subcooled cell"
  extends MBCell_Base_New;

   Real AU;
   Real C_dot;
   Real NTU;
   Real epsilon;

equation
   AU = 2*pi*rr*ll*Unom;
   C_dot = (M_dot_a + M_dot_b)/2*Medium.specificHeatCapacityCp(fluidState);
   NTU = AU/C_dot;
   epsilon = 1 - exp(-NTU);

  dzdt_a = dldt;
  dhdt_a = der(inFlow.h_outflow);
  rho_a  = Medium.density_ph(p_a, h_a);

  h_b    = Medium.bubbleEnthalpy(satState);
  dzdt_b = 0;
  dhdt_b = Medium.dBubbleEnthalpy_dPressure(satState)*dpdt;
  rho_b  = Medium.bubbleDensity(satState);

//* BOUNDARY CONDITIONS *//
 /* Enthalpies */
// h_a = inStream(inFlow.h_outflow);
//  inFlow.h_outflow = h_a;
//  outFlow.h_outflow = h_b;

/* pressures */
// p_b = outFlow.p;
 pp = p_b;
// inFlow.p = pp;
outFlow.h_outflow = h_b;
end MBCell_SC;

