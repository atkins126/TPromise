unit uPromise;

interface

uses uIPromise, uPromise.Types, System.Threading, uPromise.State;

type
  TPromise<T> = class (TInterfacedObject, IPromise<T>)
    private
      fSelfState: IPromiseState<T>;

    public
      constructor Create(pFuture: IFuture<T>);
      destructor Destroy; override;

      //-- from IPromise<T>
      function getErrorStr(): string;
      function getState(): string;
      function getValue(): T;
      function next(pProc: TAccept<T>): IPromise<T>;
      function isResolved(): boolean;
      function isRejected(): boolean;
      function isUnresolved(): boolean;
      procedure caught(pProc: TReject);
      procedure changeState(pState: IPromiseState<T>);
      procedure cancel();

  end;

implementation

uses
  System.Classes, uPromise.State.Unresolved;

{ TPromise<T> }

procedure TPromise<T>.cancel;
begin
    fSelfState.cancel();
end;

procedure TPromise<T>.caught(pProc: TReject);
begin
    fSelfState.caught(pProc);
end;

procedure TPromise<T>.changeState(pState: IPromiseState<T>);
begin
    fSelfState := pState;
end;

constructor TPromise<T>.Create(pFuture: IFuture<T>);
begin
    fSelfState := TUnresolvedState<T>.Create(self, pFuture);
end;

destructor TPromise<T>.Destroy;
begin
    fSelfState := nil;
    inherited;
end;

function TPromise<T>.getErrorStr: string;
begin
    result := fSelfState.getErrorStr();
end;

function TPromise<T>.getState: string;
begin
    result := fSelfState.getStateStr();
end;

function TPromise<T>.getValue: T;
begin
    result := fSelfState.getValue();
end;

function TPromise<T>.isRejected: boolean;
begin
    result := fSelfState.getStateStr() = 'rejected';
end;

function TPromise<T>.isResolved: boolean;
begin
    result := fSelfState.getStateStr() = 'resolved';
end;

function TPromise<T>.isUnresolved: boolean;
begin
    result := fSelfState.getStateStr() = 'unresolved';
end;

function TPromise<T>.next(pProc: TAccept<T>): IPromise<T>;
begin
    fSelfState.next(pProc);
    result := self;
end;

end.