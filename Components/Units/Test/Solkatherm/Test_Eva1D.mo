within Components.Units.Test.Solkatherm;
model Test_Eva1D
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot source_Cdot3_2(
    Mdot_0=3.148,
    cp=1907,
    rho=937.952,
    T_0=398.15)
    annotation (Placement(transformation(extent={{78,50},{58,70}})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1DConst eva(
    Mdotnom_sf=3.148,
    Mdotnom_wf=0.3335,
    Mdotconst_wf=false,
    steadystate_h_wf=true,
    steadystate_T_wall=true,
    steadystate_T_sf=false,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    redeclare package Medium1 = ThermoCycle.Media.Solkatherm_CPSmooth,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.VaporQualityDependance,
    Unom_l=4000,
    Unom_tp=4000,
    Unom_v=4000,
    N=30,
    V_sf=0.02,
    V_wf=0.02,
    Unom_sf=15000,
    pstart_wf=888343,
    Tstart_inlet_wf=356.26,
    Tstart_outlet_wf=397.75,
    Tstart_inlet_sf=398.15,
    Tstart_outlet_sf=389.45)
    annotation (Placement(transformation(extent={{-34,12},{2,50}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    Mdot_0=0.3335,
    redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
    p=888343,
    T_0=356.26)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(
    redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
    h=255110,
    p0=888343)
    annotation (Placement(transformation(extent={{58,-30},{78,-10}})));
equation
  connect(eva.inletSf, source_Cdot3_2.flange) annotation (Line(
      points={{2,40.5},{40,40.5},{40,60},{48,60},{48,59.9},{59.8,59.9}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, eva.inletWf) annotation (Line(
      points={{-71,0},{-60,0},{-60,21.5},{-34,21.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(eva.outletWf, sinkP.flangeB) annotation (Line(
      points={{2,21.5},{28,21.5},{28,-18},{56,-18},{56,-20},{59.6,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end Test_Eva1D;
