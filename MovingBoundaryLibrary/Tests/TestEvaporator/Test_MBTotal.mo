within MovingBoundaryLibrary.Tests.TestEvaporator;
model Test_MBTotal
replaceable package Medium =
      ThermoCycle.Media.SES36_CP;

  parameter Modelica.SIunits.AbsolutePressure p_out = 8.04749E5;
  parameter Modelica.SIunits.Temperature T_ex = 124+273.15;
parameter Medium.ThermodynamicState stateOut= Medium.setState_pT(p_out,T_ex);
parameter Modelica.SIunits.SpecificEnthalpy h0 = Medium.specificEnthalpy(stateOut);

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.3061,
    T_0=355.27)
    annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    cp=1907,
    rho=937.952,
    T_0=398.15)
    annotation (Placement(transformation(extent={{-46,34},{-26,54}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium = Medium, p0=810000)
    annotation (Placement(transformation(extent={{58,-28},{78,-8}})));
  ThermoCycle.Components.Units.HeatExchangers.MBeva mBeva(redeclare package
      Medium = Medium,
    A=0.0007,
    M_tot=69,
    c_wall=500,
    rho_wall=8000,
    U_SB=3000,
    U_TP=8700,
    U_SH=3000,
    Usf=1000,
    L_SB(start=22),
    L_TP(start=44),
    h_EX(start=256022),
    Void=0.8,
    L=120,
    p(start=810927),
    TwSB(start=383.15),
    TwTP(start=385.15),
    TwSH(start=398.15),
    dTsf_start=281.15,
    Tsf_SU_start=398.15)
              annotation (Placement(transformation(extent={{-46,-4},{-26,16}})));

equation
  connect(sourceMdot.flangeB, mBeva.InFlow) annotation (Line(
      points={{-77,0},{-66,0},{-66,-0.4},{-45.8,-0.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, mBeva.InFlow_sf) annotation (Line(
      points={{-27.8,43.9},{-16,43.9},{-16,12},{-26,12}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(mBeva.OutFlow, sinkP.flangeB) annotation (Line(
      points={{-26,-0.4},{-8,-0.4},{-8,2},{16,2},{16,-18},{59.6,-18}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput);
end Test_MBTotal;
