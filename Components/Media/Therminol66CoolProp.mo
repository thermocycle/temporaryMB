within Components.Media;
package Therminol66CoolProp "MB - CoolProp model of Therminol 66"
  extends ExternalMedia.Media.CoolPropMedium(
    mediumName = "Therminol66",
    substanceNames = {"T66|enable_TTSE=1|calc_transport=1"},
    ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.pT);
end Therminol66CoolProp;
