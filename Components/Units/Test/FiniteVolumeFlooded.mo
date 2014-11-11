within Components.Units.Test;
model FiniteVolumeFlooded

replaceable package Medium = ThermoCycle.Media.SES36_CP;
replaceable package MediumINC =
      ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66;

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot SourceWater(  redeclare
      package Medium =                                                              Medium,
    Mdot_0=0.3388,
    p=835000,
    T_0=333.15)
    annotation (Placement(transformation(extent={{-94,-22},{-74,-2}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot SourceINC( redeclare
      package Medium =                                                                        MediumINC,
    Mdot_0=2.97,
    p=200000,
    T_0=398.15)
    annotation (Placement(transformation(extent={{78,44},{58,64}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP SinkWater(  redeclare
      package Medium =                                                              Medium,
    h=245695,
    p0=835000)
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkINC( redeclare package
      Medium =                                                                         MediumINC,
    h=153804,
    p0=200000)
    annotation (Placement(transformation(extent={{-72,42},{-92,62}})));

  ThermoCycle.Components.Units.HeatExchangers.Hx1DInc hx1DInc( redeclare
      package Medium1 =                                                              Medium, redeclare
      package Medium2 =                                                                                                 MediumINC,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    N=20,
    Mdotnom_sf=30,
    V_sf=0.03781,
    V_wf=0.03781,
    A_sf=16.18,
    A_wf=16.18,
    Unom_sf=1500,
    Unom_l=3000,
    Unom_tp=8700,
    Unom_v=3000,
    M_wall=69,
    Mdotnom_wf=0.3388,
    pstart_sf=200000,
    pstart_wf=835000,
    Tstart_inlet_wf=333.15,
    Tstart_outlet_wf=383.15,
    Tstart_inlet_sf=398.15,
    Tstart_outlet_sf=387.15)
    annotation (Placement(transformation(extent={{-50,-4},{10,56}})));

  ThermoCycle.Components.FluidFlow.Sensors.SensTp sensTp( redeclare package
      Medium =                                                                      Medium)
    annotation (Placement(transformation(extent={{26,-2},{46,18}})));
equation
  connect(SourceWater.flangeB, hx1DInc.inlet_fl1) annotation (Line(
      points={{-75,-12},{-60,-12},{-60,14},{-43.0769,14},{-43.0769,14.4615}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SourceINC.flangeB, hx1DInc.inlet_fl2) annotation (Line(
      points={{59,54},{54,54},{54,58},{38,58},{38,39.8462},{2.61538,39.8462}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hx1DInc.outlet_fl2, sinkINC.flangeB) annotation (Line(
      points={{-42.6154,39.3846},{-54,39.3846},{-54,52},{-73.6,52}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hx1DInc.outlet_fl1, sensTp.InFlow) annotation (Line(
      points={{3.07692,14.4615},{10,14.4615},{10,4},{29,4},{29,3.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp.OutFlow, SinkWater.flangeB) annotation (Line(
      points={{43,3.2},{48,3.2},{48,0},{71.6,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=300),
    __Dymola_experimentSetupOutput);
end FiniteVolumeFlooded;
