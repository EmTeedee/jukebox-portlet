<%--
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="../init.jsp" %>

<%
String redirect = ParamUtil.getString(request, "redirect");

long albumId = ParamUtil.getLong(request, "albumId");

Album album = null;

if (albumId > 0) {
	album = AlbumLocalServiceUtil.getAlbum(albumId);
}
%>

<liferay-ui:header
	backURL="<%= redirect %>"
	title='<%= (album != null) ? album.getName() : "new-album" %>'
/>

<portlet:actionURL name='<%= (album != null) ? "updateAlbum" : "addAlbum" %>' var="addAlbumURL" />

<aui:form action="<%= addAlbumURL %>" enctype="multipart/form-data" method="post" name="fm">
	<aui:model-context bean="<%= album %>" model="<%= Album.class %>" />

	<aui:input name="albumId" type="hidden" value="<%= albumId %>" />
	<aui:input name="redirect" type="hidden" value="<%= redirect %>" />

	<aui:select label="artist" name="artistId">

		<%
		List<Artist> artists = ArtistLocalServiceUtil.getArtists(scopeGroupId);

		for (Artist artist : artists) {
		%>

			<aui:option label="<%= artist.getName() %>" value="<%= artist.getArtistId() %>" />

		<%
		}
		%>

	</aui:select>

	<liferay-ui:error exception="<%= AlbumNameException.class %>" message="please-enter-a-valid-name" />

	<aui:input name="name" />

	<aui:input name="year" />

	<aui:input name="file" type="file" />

	<c:if test="<%= (album == null) %>">
		<aui:field-wrapper label="permissions">
			<liferay-ui:input-permissions
				modelName="<%= Album.class.getName() %>"
			/>
		</aui:field-wrapper>
	</c:if>

	<aui:button-row>
		<aui:button type="submit" />

		<c:if test="<%= album != null %>">

			<%
			boolean trashEnabled = TrashUtil.isTrashEnabled(scopeGroupId);
			%>

			<c:if test="<%= AlbumPermission.contains(permissionChecker, album.getAlbumId(), ActionKeys.PERMISSIONS) %>">
				<liferay-security:permissionsURL
					modelResource="<%= Album.class.getName() %>"
					modelResourceDescription="<%= album.getName() %>"
					resourcePrimKey="<%= String.valueOf(album.getAlbumId()) %>"
					var="permissionsAlbumURL"
					windowState="<%= LiferayWindowState.POP_UP.toString() %>"
				/>

				<liferay-ui:icon
					cssClass="edit-actions"
					image="permissions"
					label="<%= true %>"
					method="get"
					url="<%= permissionsAlbumURL %>"
					useDialog="<%= true %>"
				/>
			</c:if>

			<c:if test="<%= AlbumPermission.contains(permissionChecker, album.getAlbumId(), ActionKeys.DELETE) %>">
				<portlet:actionURL name="deleteAlbum" var="deleteAlbumURL">
					<portlet:param name="albumId" value="<%= String.valueOf(album.getAlbumId()) %>" />
					<portlet:param name="moveToTrash" value="<%= String.valueOf(trashEnabled) %>" />
					<portlet:param name="redirect" value="<%= redirect %>" />
				</portlet:actionURL>

				<liferay-ui:icon-delete
					cssClass="edit-actions"
					label="<%= true %>"
					trash="<%= trashEnabled %>"
					url="<%= deleteAlbumURL %>"
				/>
			</c:if>
		</c:if>
	</aui:button-row>
</aui:form>