﻿#pragma strict

function Start () {
light.enabled=false;
}

function Update () {
if(Input.GetMouseButtonDown(0))
{

ShotFired();

}
}
function ShotFired()
 {light.enabled=true;
  yield WaitForSeconds(0.2);
  light.enabled=false;}