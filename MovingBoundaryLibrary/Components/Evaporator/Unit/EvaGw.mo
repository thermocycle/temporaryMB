within MovingBoundaryLibrary.Components.Evaporator.Unit;
model EvaGw
replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
  /* Components */
  EvaGeneral evaGeneral(
    redeclare package Medium = Medium,
    Ltotal=Ltotal,
    AA=AA,
    YY=YY,
    Mdotnom=Mdotnom,
    UnomTP=UnomTP,
    UnomSH=UnomSH,
    hstartSC=hstartSC,
    lstartSC=lstartSC,
    hstartTP=hstartTP,
    hstartSH=hstartSH,
    lstartTP=lstartTP,
    lstartSH=lstartSH,
    UnomSC=UnomSC,
    pstart=pstart,
    eps_NTU=epsNTU_pf,
    VoidFraction=VoidFraction,
    VoidF=VoidF)
    annotation (Placement(transformation(extent={{-36,-92},{44,-52}})));
  SecondaryFluid.SecondaryFluid secondaryFluid(
    AA=AA,
    YY=YY,
    L_total=Ltotal,
    Tstart=Tstartsf,
    DTstart=DTstartsf,
    n=nCV,
    Usf=Unomsf,
    eps_NTU=epsNTU_sf)
    annotation (Placement(transformation(extent={{-38,52},{42,92}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlowPF(redeclare package Medium =
                                                       Medium)
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlowPF(redeclare package Medium =
                                                       Medium)
    annotation (Placement(transformation(extent={{74,-68},{94,-48}})));
  ThermoCycle.Interfaces.Fluid.Flange_Cdot
    InFlowSF annotation (Placement(
        transformation(extent={{72,50},{92,70}})));
  MovingBoundaryLibrary.Components.Wall.wall Wall(
    cp_w=cpw,
    L_total=Ltotal,
    M_w=Mw,
    TstartWall=TstartWall)
    annotation (Placement(transformation(extent={{-16,-16},{24,20}})));

           /* GEOMETRIES */
 final parameter Integer  nCV= 3;
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
    parameter Modelica.SIunits.Mass Mw "Total mass of the wall" annotation(Dialog(group="Metal Wall",__Dymola_label="Mass wall:"));

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
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomSH=9000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unomsf=1000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));

    /* INITIAL VALUES */
parameter Modelica.SIunits.Pressure pstart=6e6 "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartSC=1E5 "SC: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartTP=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartSH=1E5 "SH: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartSC=1 "SC:Start value of length"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartTP=1 "TP:Start value of length"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartSH=1 "SH:Start value of length"
    annotation (Dialog(tab="Initialization"));

    /* initialization wall */
parameter Modelica.SIunits.Temperature TstartWall[nCV]
    "Start temperature of the wall"                                                        annotation (Dialog(tab="Initialization",group= "Wall"));
parameter Boolean SteadyStateWall = false
    "If true set Twall to zero during initialization"                                      annotation (Dialog(tab="Initialization",group= "Wall"));

     /* Steady state working fluid */
parameter Medium.SpecificEnthalpy h_pf_out = 1E5
    "Outlet enthalpy of the primary fluid"                                                 annotation(Dialog(tab="Initialization", enable= Set_h_pf_out, group= "Primary fluid"));
parameter Boolean SteadyStatePF = false
    "If true set length and h_out derivative of PF to zero"                                     annotation(Dialog(tab="Initialization",group= "Primary fluid"));
parameter Boolean Set_h_pf_out = false
    "If true set PF outlet enthalpy during initialization equal to h_pf_out"                annotation(Dialog(tab="Initialization",group= "Primary fluid"));

 /* initialization secondary fluid */
parameter Modelica.SIunits.Temperature Tstartsf
    "Start value for average temperature of inlet cell" annotation (Dialog(tab="Initialization",group= "Secondary fluid"));
parameter Modelica.SIunits.Temperature DTstartsf
    "Delta T to initialize second and third volume average temperature" annotation (Dialog(tab="Initialization",group= "Secondary fluid"));

equation
  connect(secondaryFluid.InFlow_sf, InFlowSF)
    annotation (Line(
      points={{38,72},{68,72},{68,60},{82,60}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(Wall.QmbIn, evaGeneral.mbOut)
    annotation (Line(
      points={{2.4,-14.2},{2.4,-32},{4,-32},{4,-54}},
      color={0,0,0},
      smooth=Smooth.None));

if counterCurrent then
connect( Wall.QmbOut, secondaryFluid.mbIn[nCV:-1:1]);
else
  connect(Wall.QmbOut, secondaryFluid.mbIn);
end if;

initial equation
  if SteadyStateWall then
    der(Wall.Tw) = {0,0,0};
  end if;
  if SteadyStatePF then
    der(evaGeneral.volumeSC.ll) = 0;
    der(evaGeneral.volumeTP.ll) = 0;
    der(evaGeneral.volumeSH.h_b) = 0;
  end if;
  if Set_h_pf_out then
    evaGeneral.volumeSH.h_b = h_pf_out;
  end if;

public
  record SummaryClass
    replaceable Arrays T_profile;
     record Arrays
     Modelica.SIunits.Temperature[9] Twf;
     Modelica.SIunits.Temperature[9] Tw;
     Modelica.SIunits.Temperature[9] Tsf;
     end Arrays;
     Modelica.SIunits.Length[9] l_cell;
     Modelica.SIunits.Power Qwf;
     Modelica.SIunits.Power Qsf;
  end SummaryClass;
  SummaryClass Summary(T_profile(Twf = evaGeneral.Summary.T_profile.T_cell[:],Tw= Wall.Summary.T_profile.T_cell[:], Tsf = secondaryFluid.Summary.T_profile.T_cell[:]),l_cell = evaGeneral.Summary.l_cell[:],Qwf = evaGeneral.Summary.Qtot,Qsf = secondaryFluid.Summary.Qtot);

equation
  connect(InFlowPF, evaGeneral.InFlow) annotation (Line(
      points={{-80,-60},{-58,-60},{-58,-71.6},{-36.8,-71.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaGeneral.OutFlow, OutFlowPF) annotation (Line(
      points={{43.2,-71.6},{64,-71.6},{64,-58},{84,-58}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics));
end EvaGw;
