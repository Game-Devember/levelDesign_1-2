#pragma strict

var sound : AudioClip;


function Start () {

}

function Update () {
if(Input.GetMouseButtonDown(0))
{
	GetComponent.<AudioSource>().PlayOneShot(sound,1);
}

}