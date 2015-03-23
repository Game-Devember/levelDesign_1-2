#pragma strict

function Start () {
GetComponent.<Light>().enabled=false;
}

function Update () {
if(Input.GetMouseButtonDown(0))
{

ShotFired();

}
}
function ShotFired()
 {GetComponent.<Light>().enabled=true;
  yield WaitForSeconds(0.1);
  GetComponent.<Light>().enabled=false;}