using Godot;


public partial class GameManager : Node
{
	[Export]
	public string DebugMessage { get; set; } = "Gianni";

	public override void _Ready()
	{
		GD.Print(DebugMessage);
	}
}
