#pragma strict
var player :Transform;
var movement:MonoScript;
var speed :float;

function Start () {
//GetComponent.<Animation>().CrossFade("idle");
GetComponent.<Animation>()["Take 001"].speed=1.5;

}

function Update () {
  GetComponent.<Animation>()["Take 001"].speed=1.5;
if(Input.GetAxis("Vertical"))
{
GetComponent.<Animation>().CrossFade("Take 001");
}
}
