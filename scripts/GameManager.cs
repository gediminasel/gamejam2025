using Godot;
using System;

public partial class GameManager : Node
{
	public Node2D Player { get; set; }
	
	public static GameManager Get(Node obj) {
		return (GameManager)obj.GetTree().CurrentScene.GetNode<Node>("GameManager");
	}
}
