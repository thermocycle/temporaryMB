within MovingBoundaryLibrary.Components.Condenser.Unit;
model CondFw
replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp constrainedby
    Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching = true);

    /* Components */

  Condenser.CondFlooded
    CondFlooded(
    redeclare package Medium = Medium,
    AA=AA,
    YY=YY,
    Ltotal=Ltotal,
    Mdotnom=Mdotnom,
    UnomSC=UnomSC,
    UnomTP=UnomTP,
    eps_NTU=epsNTU_pf,
    pstart=pstart,
    hstartSC=hstartSC,
    lstartSC=lstartSC,
    lstartTP=lstartTP,
    hstartTP=hstartTP,
    VoidFraction=VoidFraction,
    VoidF=VoidF)
    annotation (Placement(transformation(extent={{-24,-98},{36,-58}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InflowPF(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutflowPF(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{88,-88},{108,-68}})));
  SecondaryFluid.SecondaryFluid secondaryFluid(
    Usf=Unomsf,
    AA=AA,
    YY=YY,
    L_total=Ltotal,
    Tstart=Tstartsf,
    n=nCV,
    DTstart=DTstartsf,
    eps_NTU=epsNTU_sf)
    annotation (Placement(transformation(extent={{-34,60},{30,100}})));
  MovingBoundaryLibrary.Components.Wall.wall Wall(
    cp_w=cpw,
    L_total=Ltotal,
    M_w=Mw,
    TstartWall=TstartWall,
    n=2)
    annotation (Placement(transformation(extent={{-18,-24},{22,24}})));
  ThermoCycle.Interfaces.Fluid.Flange_Cdot InFlowSF
    annotation (Placement(transformation(extent={{84,70},{104,90}})));

/* GEOMETRIES */
 final parameter Integer  nCV= 2;
parameter Modelica.SIunits.Area AA = 0.0019 "Channel cross section";
parameter Modelica.SIunits.Length YY "Channel perimeter";
parameter Modelica.SIunits.Length Ltotal=500
    "Total length of the heat exchanger";

parameter Boolean VoidFraction = true
    "Set to true to calculate the void fraction to false to keep it constant";
    parameter Real VoidF = 0.8 "Constantat void fraction" annotation (Dialog(enable= not VoidFraction));

    /* WALL */
parameter Modelica.SIunits.SpecificHeatCapacity cpw
    "Specific heat capacity (constant)"                                                       annotation(Dialog(group="Metal Wall",__Dymola_label="Cp wall:"));
    parameter Modelica.SIunits.Mass Mw "Total mass flow of the wall" annotation(Dialog(group="Metal Wall",__Dymola_label="Mass wall:"));

  /* BOOLEAN */
parameter Boolean epsNTU_sf = false "SF-wall :If True use eps-NTU " annotation (Dialog(group = "Heat transfer"));
parameter Boolean epsNTU_pf = false "PF-wall :If True use eps-NTU  " annotation (Dialog(group = "Heat transfer"));
parameter Boolean counterCurrent = true
    "If true countercurrent - PARALLEL FLOW NOT STABLE";

    /* HEAT TRANSFER */
parameter Modelica.SIunits.MassFlowRate Mdotnom=0 "Nominal fluid flow rate" annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomSC=2500
    "SC - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomTP=9000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unomsf=1000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));

/* INITIAL VALUES */
parameter Modelica.SIunits.Pressure pstart=6e6 "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartTP=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartTP=1 "TP:Start value of length"
    annotation (Dialog(tab="Initialization"));

parameter Medium.SpecificEnthalpy hstartSC=1E5 "SC: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartSC=1 "SC:Start value of length"
    annotation (Dialog(tab="Initialization"));

    /* initialization wall */
parameter Modelica.SIunits.Temperature TstartWall[nCV]
    "Start temperature of the wall"                                                        annotation (Dialog(tab="Initialization",group= "Wall"));
parameter Boolean SteadyStateWall = false
    "If true set Twall to zero during initialization"                                      annotation (Dialog(tab="Initialization",group= "Wall"));

    /* initialization secondary fluid */
parameter Modelica.SIunits.Temperature Tstartsf
    "Start value for average temperature of inlet cell" annotation (Dialog(tab="Initialization",group= "Secondary fluid"));
parameter Modelica.SIunits.Temperature DTstartsf
    "Delta T to initialize second and third volume average temperature" annotation (Dialog(tab="Initialization",group= "Secondary fluid"));

    /* Steady state working fluid */
parameter Medium.SpecificEnthalpy h_pf_out = 1E5
    "Outlet enthalpy of the primary fluid"                                                 annotation(Dialog(tab="Initialization", enable= Set_h_pf_out, group= "Primary fluid"));
parameter Boolean SteadyStatePF = false
    "If true set length and h_out derivative of PF to zero"                                     annotation(Dialog(tab="Initialization",group= "Primary fluid"));
parameter Boolean Set_h_pf_out = false
    "If true set PF outlet enthalpy during initialization equal to h_pf_out"                annotation(Dialog(tab="Initialization",group= "Primary fluid"));

equation
    /* If statement to allow parallel or counter current structure*/
if counterCurrent then
connect( Wall.QmbOut, secondaryFluid.mbIn[nCV:-1:1]);
else
  connect(Wall.QmbOut, secondaryFluid.mbIn);
end if;
  connect(secondaryFluid.InFlow_sf, InFlowSF) annotation (Line(
      points={{26.8,80},{94,80}},
      color={255,0,0},
      smooth=Smooth.None));

initial equation
  if SteadyStateWall then
    der(Wall.Tw) = {0,0};
  end if;
if SteadyStatePF then
    der(CondFlooded.volumeTP.ll) = 0;
    der(CondFlooded.volumeSC.h_b) = 0;
  end if;
  if Set_h_pf_out then
    CondFlooded.volumeSC.h_b = h_pf_out;
  end if;
public
  record SummaryClass
    replaceable Arrays T_profile;
     record Arrays
     Modelica.SIunits.Temperature[6] Twf;
     Modelica.SIunits.Temperature[6] Tw;
     Modelica.SIunits.Temperature[6] Tsf;
     end Arrays;
     Modelica.SIunits.Length[6] l_cell;
     Modelica.SIunits.Power Qwf;
     Modelica.SIunits.Power Qsf;
  end SummaryClass;
  SummaryClass Summary(T_profile(Twf = CondFlooded.Summary.T_profile.T_cell[:],Tw= Wall.Summary.T_profile.T_cell[:], Tsf = secondaryFluid.Summary.T_profile.T_cell[:]),l_cell = CondFlooded.Summary.l_cell[:],Qwf = CondFlooded.Summary.Qtot,Qsf = secondaryFluid.Summary.Qtot);

equation
  connect(Wall.QmbIn, CondFlooded.mbOut) annotation (Line(
      points={{0.4,-21.6},{0.4,-48},{6,-48},{6,-60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(InflowPF, CondFlooded.InFlow) annotation (Line(
      points={{-100,-80},{-66,-80},{-66,-76},{-24.6,-76},{-24.6,-77.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(CondFlooded.OutFlow, OutflowPF) annotation (Line(
      points={{35.4,-77.6},{61.7,-77.6},{61.7,-78},{98,-78}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                        graphics));
end CondFw;
