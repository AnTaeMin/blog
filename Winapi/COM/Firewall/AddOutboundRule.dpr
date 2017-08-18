{$APPTYPE CONSOLE}

uses
  SysUtils,
  ActiveX,
  ComObj;

// This code adds an outbound rule using the Microsoft Windows Firewall APIs.
Procedure AddOutboundRule;
Const
  NET_FW_ACTION_ALLOW = 1;
  NET_FW_IP_PROTOCOL_TCP = 6;
  NET_FW_RULE_DIR_OUT = 2;
var
  CurrentProfiles: OleVariant;
  fwPolicy2: OleVariant;
  RulesObject: OleVariant;
  NewRule: OleVariant;
begin
  // Create the FwPolicy2 object.
  fwPolicy2 := CreateOleObject('HNetCfg.FwPolicy2');
  RulesObject := fwPolicy2.Rules;
  CurrentProfiles := fwPolicy2.CurrentProfileTypes;

  // Create a Rule Object.
  NewRule := CreateOleObject('HNetCfg.FWRule');

  NewRule.Name := 'Outbound_Rule';
  NewRule.Description := 'Allow outbound network traffic from my Application over TCP port 4000';
  NewRule.Applicationname := 'C:\Foo\MyApplication.exe';
  NewRule.Protocol := NET_FW_IP_PROTOCOL_TCP;
  NewRule.LocalPorts := 4000;
  NewRule.Direction := NET_FW_RULE_DIR_OUT;
  NewRule.Enabled := True;
  NewRule.Grouping := 'My Group';
  NewRule.Profiles := CurrentProfiles;
  NewRule.Action := NET_FW_ACTION_ALLOW;

  // Add a new rule
  RulesObject.Add(NewRule);
end;

begin
  try
    CoInitialize(nil);
    try
      AddOutboundRule;
    finally
      CoUninitialize;
    end;
  except
    on E: EOleException do
      Writeln(Format('EOleException %s %x', [E.Message, E.ErrorCode]));
    on E: Exception do
      Writeln(E.Classname, ':', E.Message);
  end;
  Writeln('Press Enter to exit');
  Readln;

end.
