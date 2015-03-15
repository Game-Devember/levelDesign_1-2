#pragma strict
var player :Transform;
var movement:MonoScript;
var speed :float;

function Start () {
animation.CrossFade("idle");
animation["Take 001"].speed=1.5;

}

function Update () {
  animation["Take 001"].speed=1.5;
if(Input.GetAxis("Vertical"))
{
animation.CrossFade("Take 001");
}
else
animation.CrossFade("idle");
}
