#pragma strict
var playerHealth=100;

function Start () {

}

function Update () {
	if(playerHealth<=0)
	{
		Destroy(gameObject);
	}
}

function TakeDamage()
 {
 	playerHealth-=50;
 }