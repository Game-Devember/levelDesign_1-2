#pragma strict
var player :GameObject;
var carCamera :GameObject;
//var smokeParticle :GameObject;
var gameStartCollider :GameObject;
function Start () {
yield WaitForSeconds(10);
carCamera.SetActive(false);
player.SetActive(true);
}

function Update () {

}