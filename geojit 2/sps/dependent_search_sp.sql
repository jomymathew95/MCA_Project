/*
created by Jomy Mathew on 25-09-2019
for Dependent search drop down list
databse:-GFSL2019


--exec SPDependent_search ''
*/



create PROCEDURE SPgetDependencymaster
(
@ctype varchar(15)
)
AS
begin

	if @ctype='CL' OR @ctype='NRE' OR @ctype='NRO' OR @ctype='NROCM' 
		BEGIN
			select d.dependency from Dependency_master d where d.client_type='I';

		END
	else
		BEGIN
			select d.dependency from Dependency_master d where d.client_type='N';

		END

end

