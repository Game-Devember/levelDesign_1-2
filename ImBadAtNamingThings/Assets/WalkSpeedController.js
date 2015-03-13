#pragma strict
var player :Transform;
function Start () {
animation["Take 001"].speed=1.5;
}

function Update () {
if(Input.GetAxis("Vertical"))
{
animation.CrossFade("Take 001");
}
else
animation.Stop("Take 001");
}