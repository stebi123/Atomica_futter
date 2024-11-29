import uvicorn
from fastapi import FastAPI
from pydantic import BaseModel
from llmware.models import ModelCatalog

class GoalRequest(BaseModel):
    current_stage: str
    goal: str
    description: str

class ExecutionPlannerModel:
    def __init__(self):
        self.model = ModelCatalog().load_model("phi-3-gguf")
    
    def generate_initial_report(self, request):
        # Initial report generation
        prompt = f"""
        Analyze the following goal details:
        Current Stage: {request.current_stage}
        Goal: {request.goal}
        Description: {request.description}

        Provide a detailed report that includes:
        1. Current situation analysis
        2. Strategic overview
        3. Key challenges
        4. Potential opportunities
        """
        
        return self.model.inference(prompt)
    
    def create_execution_plan(self, initial_report):
        # Generate step-by-step execution plan
        execution_prompt = f"""
        Based on the following goal report:
        {initial_report}

        Break down the goal into a precise, actionable step-by-step execution plan:
        - Provide a chronological sequence of actions
        - Include specific milestones
        - Offer practical tips for each stage
        - Suggest resources or tools that can help
        - Highlight potential obstacles and how to overcome them

        Format the plan in a clear, structured manner that is easy to follow.
        """
        
        return self.model.inference(execution_prompt)

app = FastAPI()
execution_planner = ExecutionPlannerModel()

@app.post("/generate-goal-roadmap")
def generate_goal_roadmap(request: GoalRequest):
    # Generate initial report
    initial_report = execution_planner.generate_initial_report(request)
    
    # Create detailed execution plan
    execution_plan = execution_planner.create_execution_plan(initial_report)
    
    return {
        "goal": request.goal,
        "initial_report": initial_report,
        "execution_plan": execution_plan
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)